#!/usr/bin/env node

/**
 * Basic Figma MCP Server for Claude Code
 * Provides tools to interact with Figma API
 */

const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} = require('@modelcontextprotocol/sdk/types.js');

class FigmaMCPServer {
  constructor() {
    this.server = new Server(
      {
        name: 'figma-integration',
        version: '0.1.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.figmaToken = process.env.FIGMA_ACCESS_TOKEN;
    this.setupHandlers();
  }

  async setupHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'get_figma_file',
            description: 'Get Figma file information and node tree',
            inputSchema: {
              type: 'object',
              properties: {
                fileKey: {
                  type: 'string',
                  description: 'Figma file key from URL',
                },
              },
              required: ['fileKey'],
            },
          },
          {
            name: 'export_figma_images',
            description: 'Export images from Figma file',
            inputSchema: {
              type: 'object',
              properties: {
                fileKey: {
                  type: 'string',
                  description: 'Figma file key',
                },
                nodeIds: {
                  type: 'array',
                  items: { type: 'string' },
                  description: 'Node IDs to export',
                },
                format: {
                  type: 'string',
                  enum: ['jpg', 'png', 'svg', 'pdf'],
                  description: 'Export format',
                },
                scale: {
                  type: 'number',
                  description: 'Export scale (1, 2, 4)',
                  default: 2,
                },
              },
              required: ['fileKey', 'nodeIds'],
            },
          },
          {
            name: 'analyze_figma_design_tokens',
            description: 'Extract design tokens (colors, typography, spacing) from Figma file',
            inputSchema: {
              type: 'object',
              properties: {
                fileKey: {
                  type: 'string',
                  description: 'Figma file key',
                },
              },
              required: ['fileKey'],
            },
          },
        ],
      };
    });

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      try {
        switch (name) {
          case 'get_figma_file':
            return await this.getFigmaFile(args.fileKey);
          
          case 'export_figma_images':
            return await this.exportFigmaImages(
              args.fileKey,
              args.nodeIds,
              args.format || 'png',
              args.scale || 2
            );
          
          case 'analyze_figma_design_tokens':
            return await this.analyzeDesignTokens(args.fileKey);
          
          default:
            throw new Error(`Unknown tool: ${name}`);
        }
      } catch (error) {
        return {
          content: [
            {
              type: 'text',
              text: `Error: ${error.message}`,
            },
          ],
        };
      }
    });
  }

  async getFigmaFile(fileKey) {
    const response = await fetch(`https://api.figma.com/v1/files/${fileKey}`, {
      headers: {
        'X-Figma-Token': this.figmaToken,
      },
    });

    if (!response.ok) {
      throw new Error(`Figma API error: ${response.statusText}`);
    }

    const data = await response.json();
    
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(data, null, 2),
        },
      ],
    };
  }

  async exportFigmaImages(fileKey, nodeIds, format, scale) {
    const params = new URLSearchParams({
      ids: nodeIds.join(','),
      format: format,
      scale: scale.toString(),
    });

    const response = await fetch(
      `https://api.figma.com/v1/images/${fileKey}?${params}`,
      {
        headers: {
          'X-Figma-Token': this.figmaToken,
        },
      }
    );

    if (!response.ok) {
      throw new Error(`Figma API error: ${response.statusText}`);
    }

    const data = await response.json();
    
    return {
      content: [
        {
          type: 'text',
          text: `Image export URLs:\n${JSON.stringify(data.images, null, 2)}`,
        },
      ],
    };
  }

  async analyzeDesignTokens(fileKey) {
    // Get file data
    const fileResponse = await fetch(`https://api.figma.com/v1/files/${fileKey}`, {
      headers: {
        'X-Figma-Token': this.figmaToken,
      },
    });

    if (!fileResponse.ok) {
      throw new Error(`Figma API error: ${fileResponse.statusText}`);
    }

    const fileData = await fileResponse.json();
    
    // Extract design tokens (simplified analysis)
    const tokens = this.extractTokens(fileData);
    
    return {
      content: [
        {
          type: 'text',
          text: `Design Tokens Analysis:\n${JSON.stringify(tokens, null, 2)}`,
        },
      ],
    };
  }

  extractTokens(fileData) {
    const tokens = {
      colors: new Set(),
      textStyles: [],
      spacing: new Set(),
    };

    // Recursive function to traverse nodes
    const traverseNodes = (nodes) => {
      for (const node of nodes || []) {
        // Extract colors
        if (node.fills) {
          node.fills.forEach(fill => {
            if (fill.type === 'SOLID' && fill.color) {
              const { r, g, b, a = 1 } = fill.color;
              tokens.colors.add(`rgba(${Math.round(r*255)}, ${Math.round(g*255)}, ${Math.round(b*255)}, ${a})`);
            }
          });
        }

        // Extract text styles
        if (node.style && node.type === 'TEXT') {
          tokens.textStyles.push({
            fontFamily: node.style.fontFamily,
            fontSize: node.style.fontSize,
            fontWeight: node.style.fontWeight,
            lineHeight: node.style.lineHeightPx,
          });
        }

        // Extract spacing (from positioning and sizing)
        if (node.absoluteBoundingBox) {
          tokens.spacing.add(node.absoluteBoundingBox.width);
          tokens.spacing.add(node.absoluteBoundingBox.height);
        }

        // Recurse into children
        if (node.children) {
          traverseNodes(node.children);
        }
      }
    };

    traverseNodes(fileData.document.children);

    return {
      colors: Array.from(tokens.colors),
      textStyles: tokens.textStyles,
      spacing: Array.from(tokens.spacing).sort((a, b) => a - b),
    };
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('Figma MCP Server running on stdio');
  }
}

const server = new FigmaMCPServer();
server.run().catch(console.error);

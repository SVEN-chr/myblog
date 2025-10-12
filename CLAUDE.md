# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hexo static blog generator site that deploys to GitHub Pages. The site uses the Volantis theme and includes Markdown posts in Chinese about technical topics.

## Common Commands

### Development
- `npm run server` or `hexo server` - Start local development server at http://localhost:4000
- `hexo new "Post Title"` - Create a new blog post in `source/_posts/`
- `hexo new draft "Draft Title"` - Create a new draft post

### Building & Deployment
- `npm run build` or `hexo generate` - Generate static files to `public/` directory
- `npm run clean` or `hexo clean` - Clean cache and generated files
- `npm run deploy` or `hexo deploy` - Deploy to GitHub Pages (requires proper `_config.yml` setup)
- `hexo clean && hexo generate && hexo deploy` - Full clean build and deploy workflow

## Project Structure

- `_config.yml` - Main Hexo site configuration
- `_config.landscape.yml` - Landscape theme configuration (backup)
- `source/_posts/` - Blog posts in Markdown format with front matter
- `scaffolds/` - Post templates (draft.md, post.md, page.md)
- `themes/volantis/` - Active theme directory (in node_modules)
- `public/` - Generated static site (after build)
- `.github/dependabot.yml` - Dependabot configuration for npm updates

## Theme Configuration

The site uses the Volantis theme (`hexo-theme-volantis`). Key theme settings are in `_config.yml`. The theme requires Pug and Stylus renderers which are already installed:

- `hexo-renderer-pug` - Required for Pug template rendering
- `hexo-renderer-stylus` - Required for Stylus CSS preprocessing

## Deployment Configuration

The site is configured to deploy to GitHub Pages via the git deployer:
- Repository: `https://github.com/SVEN-chr/SVEN-chr.github.io.git`
- Branch: `main`

## Content Management

Posts are stored in `source/_posts/` with the format `YYYY-MM-DD-title.md`. Each post includes front matter with:
- title
- date (YYYY-MM-DD HH:mm:ss format)
- tags (array)
- categories (array)
- toc (boolean for table of contents)

## Dependencies

Key Hexo plugins and renderers:
- `hexo-generator-archive` - Archive pages
- `hexo-generator-category` - Category pages
- `hexo-generator-index` - Index page generation
- `hexo-generator-tag` - Tag pages
- `hexo-renderer-ejs` - EJS template rendering
- `hexo-renderer-marked` - Markdown rendering
- `hexo-renderer-pug` - Pug template rendering (required for Volantis)
- `hexo-renderer-stylus` - Stylus CSS preprocessing (required for Volantis)
- `hexo-deployer-git` - Git deployment functionality
# Claude Code Context

## About Me
- DevOps engineer with 20 years of experience
- GitHub username: lavabyrd
- Email: admin@lavabyrd.space (for commits)

## Development Environment
- **Shell**: Fish with custom aliases and functions
- **Editor**: Neovim with LazyVim configuration
- **File Manager**: Yazi with vim-like keybindings
- **Directory Navigation**: Zoxide for smart jumping
- **Version Control**: Lazygit for terminal-based Git workflows
- **Shell History**: Atuin for enhanced history management
- **Jira**: Use local `jira` CLI binary for all ticket operations (configured as mark@figment.io)
  - Comments: `jira issue comment add ISSUE-KEY "comment"` (no --body flag)

## Working Preferences
- Focus on portability, security, and readable practices
- Keep code comments minimal unless particularly complex
- Never identify as AI in comments, PRs, or commits
- Never add Co-authored-by trailers for Claude or AI in git commits
- Use GNU Stow for dotfiles management
- Prefer editing existing files over creating new ones
- Test configurations thoroughly before deployment

## Dotfiles Structure
- Main repo: `~/dotfiles` 
- All configs symlinked via `stow config`
- Includes install script and test suite
- Protected by comprehensive .gitignore

## Claude Code Access
- Primary working directory: `/Users/markpreston/.config`
- Dotfiles repository: `/Users/markpreston/dotfiles`

## Code Style
- Clean, maintainable code
- Follow existing patterns and conventions
- Security-first approach
- No unnecessary dependencies

## Git Commit Messages
- Format: `[TICKET-ID] Description of change`
- Example: `[VULN-9361] Bump urllib3 to 2.6.3 to fix vuln`
- Do not use conventional commit prefixes like `chore(scope):`, `fix:`, `feat:`, etc.
- Keep descriptions concise and descriptive

## Communication Style
- Embody the role of the most qualified subject matter experts
- Keep conversations natural without mentioning artificial intelligence
- No need to apologize or express regret in answers
- Avoid disclaimers about capabilities
- If something is beyond knowledge, simply say "I don't know"
- Ask for clarification when something seems unclear
- When programming, return full updated code, not brevity code
- Do not return untouched code
- Consider context sufficiency before responding
- Ask clarifying questions if key details are uncertain or unclear
- Do not add comments to code
- Tell it like it is without sugar-coating responses
- Never add any dash (like an emdash) in generated content
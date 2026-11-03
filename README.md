# Skills

Agent skills and Claude Code plugins by Piotr Obidowski. Each plugin lives in `plugins/<name>/` with its skills in `plugins/<name>/skills/<skill>/SKILL.md`, following the [Agent Skills](https://agentskills.io/specification) format, so they work in Claude Code, Cursor, Codex, Gemini CLI and any agent that reads `SKILL.md`.

## Plugins

| Plugin | What it does | Skills |
|---|---|---|
| [visualizee](plugins/visualizee/) | AI rendering for architects, interior designers, product and game designers, via [Visualizee](https://visualizee.ai/?utm_source=agent-skill&utm_medium=skill&utm_campaign=repo-readme) | `architectural-render`, `interior-restyle`, `product-colorways`, `game-asset-render`, `render-video`, `image-to-3d` |

![Model screenshot to photoreal render](plugins/visualizee/assets/architectural-render.jpg)

## Install

**skills.sh**

```bash
npx skills add pobidowski/skills                              # choose skills from a list
npx skills add pobidowski/skills --skill architectural-render # a single skill
```

**Claude Code**

```
/plugin marketplace add pobidowski/skills
/plugin install visualizee@pobidowski-skills
```

**Manual**

```bash
git clone https://github.com/pobidowski/skills
cp -r skills/plugins/visualizee/skills/* ~/.claude/skills/
```

Each plugin's README covers its own setup (accounts, keys, MCP servers).

## Repository layout

```
.claude-plugin/marketplace.json   Claude Code marketplace: one entry per plugin
plugins/<plugin>/
  .claude-plugin/plugin.json      plugin manifest
  README.md                       setup, examples, pricing
  assets/                         README images
  shared/                         helpers copied into skills by scripts/sync-shared.sh
  skills/<skill>/SKILL.md         one folder per skill (plus scripts/ when needed)
scripts/sync-shared.sh            copies shared helpers into each skill
```

To add a plugin: create `plugins/<name>/` with the same shape, add an entry to `.claude-plugin/marketplace.json`, and run `claude plugin validate .`.

## Licence

MIT, see [LICENSE](LICENSE). Third-party services used by a skill have their own terms.

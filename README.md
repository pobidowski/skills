# Skills

Agent skills and Claude Code plugins by Piotr Obidowski. They follow the [Agent Skills](https://agentskills.io/specification) format, so they work in Claude Code, Cursor, Codex, Gemini CLI and any agent that reads `SKILL.md`.

## Visualizee skills

AI rendering for architects, interior designers, product and game designers, powered by [Visualizee](https://visualizee.ai/?utm_source=agent-skill&utm_medium=skill&utm_campaign=repo-readme). Each skill does one job, tells your agent what to ask you, how to word the request, which quality to pick and what it costs.

### architectural-render

Turn a SketchUp, Revit, ArchiCAD or Rhino screenshot, or a hand sketch, into a photoreal render. Massing, windows and camera stay exactly as designed; light, materials, sky and planting become real.

![Model screenshot to photoreal render](plugins/visualizee/assets/architectural-render.jpg)

### interior-restyle

Stage an empty room or restyle a room photo: a new style, wall colour, flooring, cabinets or a single furniture swap. Walls, windows and camera stay as photographed.

![Empty room to staged living room](plugins/visualizee/assets/interior-restyle.jpg)

### product-colorways

One product image in, consistent variants out: new colours and materials, clean studio packshots, transparent cutouts or lifestyle scenes, with the shape and details kept identical.

![One sneaker, three colorways](plugins/visualizee/assets/product-colorways.jpg)

### game-asset-render

Props, icons, character turnaround sheets, UI elements and concept art that match your game's style, with real transparent PNGs for sprites and icons.

![Key art to character turnaround sheet](plugins/visualizee/assets/game-asset-render.jpg)

### render-video

Animate a still into a 3 to 30 second clip: an architectural push-in, a product turntable, a car reveal, a room flythrough. The skill always states the price before rendering.

![Still render and the last frame of a 3 s push-in](plugins/visualizee/assets/render-video.jpg)

### image-to-3d

One to four views of a single object become a textured GLB in 2 to 4 minutes, ready for Unity, Godot, Unreal, Blender or three.js.

![Three views to a textured model and its clay mesh](plugins/visualizee/assets/image-to-3d.jpg)

## How it works

1. **You ask in plain words.** "Render this SketchUp screenshot at dusk" or "make a 3D model of this chest". The matching skill loads on its own, or you call it by name (`/visualizee:architectural-render` in Claude Code).
2. **The agent asks only what it needs.** Usually the image and what should change. Then it writes one sentence for Visualizee: what changes and what must stay exactly as it is.
3. **It picks a quality level and tells you the cost.** Base for quick drafts (80 credits per image), Pro for client work (150), Ultra for final shots (300). Video and 3D are always priced before anything renders.
4. **Visualizee renders.** Through the Visualizee MCP server (any plan, sign in once, no key) or the REST API with `VISUALIZEE_API_KEY` (Pro and Max, for scripts and batches). Slow renders are collected when they finish, never started twice.
5. **You get the file.** An image URL, an MP4 or a GLB, saved into your project if you like. Every render is also in your Visualizee workspace, where you can keep editing it with Vizzy. Failed renders are refunded automatically.

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

**Connect Visualizee** (once):

```bash
claude mcp add --transport http visualizee https://visualizee.app/api/mcp
```

Then run `/mcp` and sign in. Or set `VISUALIZEE_API_KEY` from the Account page at [visualizee.app](https://visualizee.app/?utm_source=agent-skill&utm_medium=skill&utm_campaign=repo-readme) on Pro or Max. Plans: Free (400 credits to try, about 5 images), Hobby $20/mo, Pro $40/mo, Max $80/mo. Full setup and pricing: [plugins/visualizee](plugins/visualizee/).

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

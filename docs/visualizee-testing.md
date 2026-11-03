# Test log

Live tests run on 2026-11-03 through the Visualizee MCP server on a Max account, with the prompts from each SKILL.md. Total spend: 1,110 credits.

| Skill | Call | Level | Credits | Result |
|---|---|---|---|---|
| architectural-render | `render_image`, SketchUp screenshot as reference | Base | 80 | Completed in one call, design and camera kept |
| interior-restyle | `render_image`, empty room photo as reference | Base | 80 | Completed; Base reframed the windows slightly, hence the "use Pro for clients" advice |
| product-colorways | `render_image`, 4-up sheet, top-left sneaker named | Base | 80 | Completed, shape kept, new colorway |
| game-asset-render | `render_image`, `background: "transparent"` | Pro | 150 | Completed, PNG with real alpha (corner alpha 0) |
| image-to-3d | `render_3d_model` from the transparent lantern, then `get_render` | Base | 300 | Returned pending, collected with `get_render` about 2 minutes later, 6.2 MB GLB |
| render-video | `render_video`, 3 s 720p from the house render | Base | 420 | Completed in one call. `audio: false` on Base was refused at the time; fixed in the API on 2026-11-03 (now ignored, re-checked live) |

REST path: `scripts/vz.sh` was tested against a local mock of `/api/v1` (model picking, submit with `Idempotency-Key`, polling, error envelopes) and against production for the `401 unauthorized` envelope. No live REST render was made because no API key was available locally.

## API follow-up (2026-11-03)

The REST API gained `quality: base | pro | ultra` on `/render/image` and now defaults to Pro instead of Ultra, `GET /models` reports each model's `quality`, and MCP `render_video` ignores `audio` on models without sound. The skills dropped their workarounds (picking a `model_id`, leaving `audio` out on Base). Re-checked live: an MCP Base video call with `audio: false` now passes the audio check. The REST `quality` field is not yet exercised with a live key.

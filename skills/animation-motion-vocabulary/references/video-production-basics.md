# Video Production Basics

Terminology and patterns for programmatic video creation, rendering pipelines, and post-production. Use this reference when working with Remotion, Hyperframe, or any video-as-code output.

---

## 1. Resolution & Aspect Ratio Reference

| Format | Aspect Ratio | Common Resolution | Frame Rate | Common Use |
|:---|:---|:---|:---|:---|
| **Vertical / Portrait (Short)** | 9:16 | 1080×1920 | 30fps or 60fps | TikTok, Reels, Shorts, Stories |
| **Landscape (HD)** | 16:9 | 1920×1080 | 24fps, 30fps, or 60fps | YouTube, Vimeo, presentations |
| **Landscape (4K UHD)** | 16:9 | 3840×2160 | 24fps, 30fps, or 60fps | High-quality YouTube, cinema |
| **Square** | 1:1 | 1080×1080 | 30fps | Instagram feed, social media posts |
| **Portrait (Social)** | 4:5 | 1080×1350 | 30fps | Instagram feed, Facebook feed |
| **Cinematic** | 21:9 | 3840×1620 | 24fps | Widescreen, movie theater |
| **Cinematic DCI 2K** | ~1.9:1 | 2048×1080 | 24fps | Digital cinema projection |
| **Ultrawide** | 32:9 | 3840×1080 | 30fps or 60fps | Multi-monitor, panoramic |

### Resolution Naming Conventions

| Term | Horizontal Pixels | Notes |
|:---|:---|:---|
| **SD (480p)** | 854×480 | Standard definition, rarely used today |
| **HD (720p)** | 1280×720 | Entry-level HD |
| **Full HD (1080p)** | 1920×1080 | Standard HD, most common output |
| **QHD / 2K (1440p)** | 2560×1440 | High-end monitors, some social platforms |
| **4K UHD (2160p)** | 3840×2160 | Premium, streaming, YouTube |

---

## 2. Frame Rates

| FPS | Character | Best For |
|:---|:---|:---|
| **24fps** | Cinema-standard, slight motion blur | Narrative video, cinematic feel |
| **25fps** | PAL standard (Europe broadcast) | TV content, UK/European video |
| **30fps** | NTSC standard, web video | YouTube, social media, standard web video |
| **48fps** | High frame rate, very smooth | HFR cinema (The Hobbit), action/sports |
| **60fps** | Very smooth, minimal motion blur | Gaming, fast-paced content, screen recordings |

**Remotion default:** 30fps. Set via `useVideoConfig().fps`.

---

## 3. Codecs & Containers

### Container Formats (Wrappers)

| Container | File Extension | Best For |
|:---|:---|:---|
| **MP4** | `.mp4` | **Default** — universal compatibility, streaming |
| **WebM** | `.webm` | Web-native, smaller size, transparency (alpha) |
| **MOV** | `.mov` | Production/intermediate, high quality, ProRes |
| **AVI** | `.avi` | Legacy, not recommended |
| **MKV** | `.mkv` | Archival, multiple tracks |

### Video Codecs

| Codec | Quality vs Size | Best For |
|:---|:---|:---|
| **H.264 (AVC)** | Good quality, small size | **Default** — universal playback, web, mobile |
| **H.265 (HEVC)** | Better quality, ~50% smaller than H.264 | 4K content, modern devices only |
| **VP9** | Similar to H.265 | WebM, YouTube compression |
| **AV1** | Best compression, ~30% better than H.265 | Future-proof, but slow to encode |
| **ProRes** | Massive file size, lossless quality | Editing/production workflow, not for delivery |
| **Animation (RLE)** | Lossless, large | Screen recordings, UI demos, simple graphics |

### FFmpeg Presets for Output

```bash
# H.264 — good quality, fast encode (default for delivery)
ffmpeg -i input.mp4 -c:v libx264 -preset medium -crf 23 -c:a aac output.mp4

# H.264 — high quality (for final delivery)
ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 18 -c:a aac output.mp4

# H.265 — smaller file, modern quality
ffmpeg -i input.mp4 -c:v libx265 -crf 28 -c:a aac output.mp4

# ProRes — lossless intermediate (for editing)
ffmpeg -i input.mp4 -c:v prores_ks -profile:v 3 -c:a pcm_s16le output.mov

# WebM with alpha transparency
ffmpeg -i input.mp4 -c:v libvpx-vp9 -pix_fmt yuva420p output.webm
```

---

## 4. Captions & Subtitles

### Format Comparison

| Format | Extension | Type | Best For |
|:---|:---|:---|:---|
| **SRT** | `.srt` | Simplest text-based | Universal compatibility, social media |
| **VTT (WebVTT)** | `.vtt` | HTML5 native, supports styling | Web video, HTML `<track>` elements |
| **TTML / DFXP** | `.ttml` | XML-based, rich formatting | Broadcast, streaming services |
| **ASS / SSA** | `.ass` | Advanced styling, karaoke effects | Fansubs, anime, complex captions |
| **Burned-in (hardsub)** | (in video) | Text rendered into video frames | Social media (TikTok, Reels) where external subtitle file isn't supported |

### SRT Format
```
1
00:00:01,000 --> 00:00:04,000
Hello, welcome to this video.

2
00:00:04,500 --> 00:00:08,000
Today we'll cover animation
vocabulary and best practices.
```

### WebVTT Format
```
WEBVTT

00:00:01.000 --> 00:00:04.000
Hello, welcome to this video.

00:00:04.500 --> 00:00:08.000
Today we'll cover <c.highlight>animation vocabulary</c>
and best practices.

STYLE
::cue(.highlight) { background: rgba(255,255,0,0.3); }
```

### Caption Strategy Decision

| Platform | Recommended Format | Approach |
|:---|:---|:---|
| **YouTube** | SRT or automatic | Upload SRT as separate track |
| **TikTok / Reels / Shorts** | Burned-in | Render captions directly into video frames for guaranteed visibility |
| **Web (HTML5)** | VTT | Use `<track kind="captions" src="captions.vtt" srclang="en">` |
| **Vimeo** | SRT, VTT, or DFXP | Upload as text track |
| **Mobile app** | VTT or SRT | Parse and display over video player |

---

## 5. Color Terminology

| Term | Definition | Practical Use |
|:---|:---|:---|
| **Color space** | The range (gamut) of colors a format can represent | sRGB (web), Rec.709 (HD video), DCI-P3 (cinema), Rec.2020 (HDR) |
| **Rec.709** | Standard color space for HD video | Default for most output; consistent across devices |
| **sRGB** | Standard color space for web | Use for web-embedded video, same gamut as Rec.709 |
| **DCI-P3** | Wider gamut used in digital cinema and HDR | Premium displays (iPhone, iPad Pro, modern monitors) |
| **Gamma** | Relationship between pixel value and luminance | sRGB gamma ~2.2; Rec.709 gamma ~2.4 |
| **LUT (Look-Up Table)** | Pre-computed color transformation matrix | Apply a film look, color grade, or technical conversion |
| **Color grade** | Creative adjustment of colors for mood/style | Warm vs cool, teal/orange, desaturated |
| **White balance** | Neutral reference point for color temperature | 5600K (daylight), 3200K (tungsten) |
| **Luma / Luminance** | Perceived brightness of a pixel | Used for audio waveform visualization height mapping |

---

## 6. Text-to-Speech & Voiceover

### TTS Terminology

| Term | Definition |
|:---|:---|
| **SSML (Speech Synthesis Markup Language)** | XML markup for controlling TTS output (emphasis, pitch, rate, pauses) |
| **Prosody** | The rhythm, stress, and intonation of speech — controllable via SSML `<prosody>` tag |
| **Phoneme** | A unit of sound that distinguishes one word from another |
| **SSRF markers** | Sentence-boundary timestamps used to align text with audio waveform |
| **Viseme** | Visual representation of a phoneme (mouth shape) for lip-sync animation |

### TTS Provider Vocabulary

| Provider | Voice Quality | SSML Support | Best For |
|:---|:---|:---|:---|
| **ElevenLabs** | Excellent, natural, emotional | Partial | Narration, character voices, premium content |
| **OpenAI TTS** | Very good, natural | No | Quick narration, chat-style voiceovers |
| **Google Cloud TTS** | Good, many languages | Full SSML | Multilingual content, SSML-driven control |
| **Amazon Polly** | Good, many options | Full SSML | Cost-effective, SSML-rich content |
| **Whisper + XTTS** | Open-source, self-hosted | Limited | No API dependency, privacy-sensitive content |

### Audio Sync Vocabulary

| Term | Definition | Implementation |
|:---|:---|:---|
| **Timed alignment** | Matching text words to specific frame timestamps | `transcribe()` output with word-level timestamps |
| **Beat-sync** | Visual animations that trigger on audio peak frames | Analyze waveform amplitude per frame, trigger effects on peaks |
| **Waveform visualization** | Animated bars/shapes driven by audio amplitude | Map audio sample values to visual element scales/heights |
| **Lip-sync** | Mouth shapes animated to match spoken phonemes | Map phoneme → viseme → mouth shape, animate at ~12fps |
| **Crossfade (audio)** | Smoothly transition between two audio tracks | Fade out track A while fade in track B over 0.5-2s overlap |

---

## 7. Thumbnail & Poster Generation

| Term | Definition | Best Practice |
|:---|:---|:---|
| **Poster frame** | Static image representing a video before playback | Use a visually impactful frame, often with title overlay |
| **Keyframe** | A representative frame from the video | Extract at 10-25% of video duration for variety |
| **Thumbnail** | Small preview image, clickable to play | 1280×720 (16:9), include text overlay, high contrast |
| **Spritesheet** | Grid of thumbnail frames for scrubbing preview | Used by YouTube for hover-to-preview on seek bar |

### Remotion — Poster Frame
```typescript
// In your Remotion composition, export a specific frame as still
// Component renders frame at index `posterFrame` (e.g., frame 10)
export const Poster: React.FC = () => {
  return (
    <div style={{ position: 'relative', width: 1280, height: 720 }}>
      <img src={background} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
      <h1 style={{
        position: 'absolute',
        bottom: 40,
        left: 40,
        color: 'white',
        fontSize: 48,
        textShadow: '0 2px 10px rgba(0,0,0,0.5)',
      }}>
        Video Title
      </h1>
    </div>
  );
};
// Extract as PNG: npx remotion still src/index.ts Poster out/thumbnail.png --frame=10
```

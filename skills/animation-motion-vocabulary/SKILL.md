---
name: animation-motion-vocabulary
description: Standard dictionary and practical execution guide for animation, UI motion, and video-as-code terminology. Covers transitions, gestures, micro-interactions, easing curves, video composition, and UI component vocabulary.
---

# Animation, UI Motion & Video Vocabulary Guide

## Overview

This skill provides a standard vocabulary and actionable workflow for describing, implementing, and debugging animations, UI motion, and programmatic video. It ensures precise communication when designing UI transitions, micro-interactions, gesture-driven motion, and video-as-code compositions (Remotion, Hyperframe).

The skill is organized as:
- **Step-by-step execution guide** — a practical workflow for the agent to follow
- **Quick reference tables** — summaries for rapid lookup during implementation
- **Modular references** (`references/`) — deep-dives on easing curves, UI/UX vocabulary, and video production
- **Examples** (`examples/`) — real usage patterns and before/after comparisons

## Trigger Conditions

Activate this skill when the user request involves:

- **Animation or motion design** — transitions, entrances/exits, micro-interactions, hover effects, loading animations, scroll-triggered effects
- **Gesture-driven interaction** — swipe, drag, pinch, pull-to-refresh, overscroll, long-press
- **Shared element / layout animations** — FLIP technique, AnimatedPresence, layout transitions between routes
- **Video composition** — programmatic video (Remotion, Hyperframe), motion graphics, kinetic typography, slideshows, video intros
- **Easing or timing specification** — spring curves, cubic-bezier, keyframes, stagger delays
- **UI component vocabulary** — naming or classifying surfaces (modal, sheet, popover, drawer, accordion), navigation patterns, design tokens

**Do NOT activate** for general UI layout without motion, pure data visualization without animation, or static design system documentation.

## Prerequisites & Dependencies

- **CSS** — `transform`, `opacity`, `clip-path`, `animation`, `transition`, `@keyframes`, `prefers-reduced-motion`
- **Framer Motion** — `motion.div`, `AnimatePresence`, `variants`, `layoutId`, `useScroll`, `useSpring`
- **React Native Reanimated** — `useSharedValue`, `withSpring`, `withTiming`, `useAnimatedStyle`, `LayoutAnimationConfig`
- **Remotion** — `useCurrentFrame()`, `interpolate()`, `spring()`, `Sequence`, `AbsoluteFill`, `continueRender()`
- **Hyperframe** — `data-start`, `data-duration`, timeline attributes, GSAP, headless browser rendering
- **GSAP / Anime.js** — `gsap.to()`, `timeline()`, `stagger`, `ease` parameter

## Folder Structure

- **`scripts/`** — Validation and diagnostic scripts for animation checks
- **`examples/`** — Vocabulary usage patterns and before/after comparisons
- **`resources/`** — Visual references, screenshots, or templates (currently empty)
- **`references/`** — Modular sub-documents for deep-dive topics:
  - `easing-curves-guide.md` — Full easing curve reference with use cases and code
  - `ui-ux-vocabulary.md` — Deep glossary of UI/UX patterns, state, accessibility, gestures
  - `video-production-basics.md` — Resolution tables, codecs, captions, color, TTS

---

## Step-by-Step Execution Guide

### Step 1: Probe the Request & Environment

Before reaching for vocabulary, determine exactly what the user needs:

1. **Read the existing codebase** — check for:
   - An animation library already in use (Framer Motion, Reanimated, CSS transitions, GSAP)
   - Existing motion preferences (check for `prefers-reduced-motion` media queries, animation utility classes)
   - The framework (React, React Native, HTML-only, Remotion project)
2. **Ask clarifying questions** if the request is ambiguous:
   - "Is this a UI transition (state change) or a decorative animation?"
   - "Should this respond to user interaction (hover, click, scroll) or play automatically?"
   - "Is this for a video composition (exported to MP4) or a live web interface?"
   - "Do you want this to feel snappy (100-200ms) or dramatic (300-500ms)?"
   - "Should it respect the user's reduced motion preference?"

### Step 2: Classify & Scope the Animation Need

Use the decision matrix below to identify the animation category:

| If the user wants... | Category | Typical Duration | Key Properties |
|:---|:---|:---|:---|
| A button press effect, toggle switch, or hover state change | **Micro-interaction** | 100-250ms | `scale`, `opacity`, `background-color` |
| A modal/sheet/popover appearing or disappearing | **Surface entrance/exit** | 200-400ms | `translateY`, `opacity`, `scale` |
| Items appearing one after another in a list | **Staggered entrance** | 50-150ms stagger delay per item | `translateY`, `opacity`, `scale` |
| Page or route transitions (navigating between screens) | **Page transition** | 250-500ms | Shared element (`layoutId`), crossfade, slide |
| A loading spinner, skeleton pulse, or shimmer bar | **Continuous / decorative** | Looping | `rotate`, `opacity` pulse, `background-position` |
| A parallax scroll, sticky header, or scroll-triggered reveal | **Scroll-driven motion** | Tied to scroll position | `translateY`, `scale`, `clip-path` tied to scroll offset |
| A drag-to-dismiss card, swipeable row, or slider | **Gesture-driven motion** | Physics-based (spring) | `translateX`/`translateY` tied to gesture, `withSpring` |
| Elements sharing an identity across screens (e.g. list → detail) | **Shared element / layout animation** | 200-400ms | `layoutId` (Framer Motion), `sharedTransitionTag` (Reanimated) |
| A full video composition with music, text, and scenes | **Video-as-code** | Frame-counted | `useCurrentFrame()`, `Sequence`, `interpolate` |
| Text animating letter-by-letter or word-by-word | **Kinetic typography** | Staggered per character/word | `opacity` + `translateY` stagger, `clip-path` reveal |

### Step 3: Select Vocabulary & Implementation Philosophy

Once the category is identified, choose the right framework and vocabulary:

**For web UI animations:**
| Framework | Best for | Key patterns |
|:---|:---|:---|
| **CSS transitions/animations** | Simple micro-interactions, hover effects, `prefers-reduced-motion` fallbacks | `transition: transform 200ms ease-out`, `@keyframes pulse` |
| **Framer Motion** | Complex React UI animations, shared element (`layoutId`), `AnimatePresence` for mount/unmount | `motion.div`, `variants`, `layoutId`, `useScroll`, `drag` |
| **GSAP** | Timeline-choreographed sequences, scroll-triggered animations, cross-browser precision | `gsap.timeline()`, `ScrollTrigger`, `stagger: 0.1` |
| **CSS `@view-transition` (View Transitions API)** | Native cross-document page transitions, SPA route transitions | `document.startViewTransition()`, `::view-transition-old/new` |

**For native mobile animations:**
| Framework | Best for | Key patterns |
|:---|:---|:---|
| **React Native Reanimated** | High-performance native animations, gesture-driven interactions, shared element transitions | `useSharedValue`, `withSpring`, `useAnimatedStyle`, `LayoutAnimationConfig` |
| **React Native LayoutAnimation** | Simple layout changes and list insertions/removals | `LayoutAnimation.configureNext()` |

**For video compositions:**
| Framework | Best for | Key patterns |
|:---|:---|:---|
| **Remotion** (React-based) | Data-driven videos, modular components, programmatic video with React | `useCurrentFrame()`, `interpolate()`, `Sequence`, `spring()` |
| **Hyperframe** (HTML-based) | Agent-native HTML videos, timeline data attributes, lightweight DOM | `data-start`, `data-duration`, GSAP timelines, headless rendering |

### Step 4: Implement with Correct Timing & Safety

#### Timing Rules
- **UI micro-interactions**: 100-300ms. Use `ease-out` for natural feel.
- **Surface entrances**: 200-400ms. Use spring for bounce or eased for polished.
- **Page transitions**: 250-500ms. Match the platform (iOS 400ms default, Material 300ms).
- **Stagger delays**: 30-80ms between items for subtle feel; 100-150ms for dramatic.
- **Video frame timing**: Bind ALL timing to frame numbers, never wall-clock time.

#### Deterministic Video Rendering
In video-as-code (Remotion, Hyperframe), you **must**:
- Use `useCurrentFrame()` (Remotion) or `data-start`/`data-duration` (Hyperframe) for all timing
- NEVER use `setTimeout`, `setInterval`, `Date.now()`, `Math.random()` without a seed
- NEVER use CSS `transition: all 0.3s` or CSS `animation-delay` — these drift across renders
- Preload all assets with `delayRender()` / `continueRender()` (Remotion)

#### Performance: Avoid Layout Thrashing
- Animate only `transform` (translate, scale, rotate) and `opacity`
- NEVER animate `width`, `height`, `top`, `left`, `margin`, `padding` in frame loops
- For entrance animations, start at `scale(0.8)` + `opacity(0)` and animate to `scale(1)` + `opacity(1)`

#### Accessibility: Reduced Motion
- Wrap decorative animations in `@media (prefers-reduced-motion: reduce)` media query
- Provide a `reducedMotion` prop/state that disables parallax, shimmer, and decorative effects
- Essential animations (loading spinners, progress bars, focus rings) should remain active in reduced motion mode, but simplified
- For Framer Motion: use `useReducedMotion()` hook from `framer-motion`
- For React Native: use `AccessibilityInfo.isReduceMotionEnabled()`

### Step 5: Verify & Hand-off

After implementing, verify:
1. **Duration feels right** — micro-interactions should feel instant, not sluggish
2. **Easing feels natural** — ease-out for UI, custom curve for brand motion, spring for playful
3. **Reduced motion works** — toggle OS setting and confirm fallbacks
4. **No layout shift** — animations don't cause CLS (Cumulative Layout Shift)
5. **Deterministic output** (video) — re-render twice, confirm identical frames

Output to the user:
- Summary of what was implemented and which vocabulary/patterns were used
- Any trade-offs made (e.g., "Used spring for bounce effect, but fallback to ease-out for reduced motion")
- Instructions for testing (e.g., "Toggle reduced motion in DevTools to verify fallback")

---

## Quick Reference Tables

### Animation Types & Vocabulary

| Term | Definition | When to Use | Typical Duration |
|:---|:---|:---|:---|
| **Fade in / out** | Opacity 0→1 or 1→0 | Simple entrances/exits, overlays | 150-300ms |
| **Slide in** | Element moves from off-screen into position | Drawers, sheets, bottom bars | 250-400ms |
| **Scale in** | Element grows from smaller to full size | Cards appearing, modal dialogs | 200-350ms |
| **Pop in** | Scale with overshoot/bounce | Celebratory elements, icons appearing | 200-400ms |
| **Reveal** | Clip-path or mask animated to uncover content | Hero sections, text reveals | 300-600ms |
| **Shimmer / Sweep** | Moving gradient or light bar | Loading skeletons, premium text | Looping, 1-2s cycle |
| **Typewriter** | Characters appear sequentially | Terminal output, dramatic text | Per-character, 30-80ms |
| **Ken Burns** | Slow pan + zoom on static image | Video backgrounds, photo slideshows | 3-10s (video), slower for web |
| **Parallax** | Layers move at different speeds on scroll | Hero sections, storytelling pages | Scroll-tied |
| **Stagger** | Multiple items animate with sequenced delays | Lists, grids, feature cards | 50-150ms per item |
| **Spring** | Physics-based motion with tension/damping/mass | Natural-feeling UI, playful interactions | Physics-based (not fixed) |
| **Morph** | Shape or text smoothly transforms into another | Animated counters, shape transitions | 300-600ms |

### Common Easing Curves

| Name | Cubic Bezier | Character | When to Use |
|:---|:---|:---|:---|
| **Ease-out** | `cubic-bezier(0, 0, 0.2, 1)` | Starts fast, decelerates | Default for UI entrances, micro-interactions |
| **Ease-in-out** | `cubic-bezier(0.4, 0, 0.2, 1)` | Gradual acceleration/deceleration | Page transitions, shared element animations |
| **Ease-in** | `cubic-bezier(0.4, 0, 1, 1)` | Starts slow, accelerates | Exit animations (things leaving) |
| **Material / Standard** | `cubic-bezier(0.4, 0, 0.2, 1)` | Standard Android/Material curve | Material Design components |
| **Deceleration / Emphasis** | `cubic-bezier(0, 0, 0.2, 1.25)` | Overshoots slightly | Hero animations, emphasized entrances |
| **Spring (soft)** | N/A (physics) | Damping: 20, Stiffness: 170 | Gentle UI bounce, list items |
| **Spring (snappy)** | N/A (physics) | Damping: 12, Stiffness: 200 | Playful interactions, toggle switches |

See [easing curves guide](references/easing-curves-guide.md) for full details and code snippets.

### UI State Vocabulary

| Term | Definition | Visual Pattern |
|:---|:---|:---|
| **Loading / Skeleton** | Placeholder content shown while data loads | Shimmer, pulse, skeleton shapes |
| **Empty state** | UI shown when no data exists | Illustration + message + CTA |
| **Error state** | UI shown when an operation fails | Alert banner, inline error, toast |
| **Success state** | UI shown on successful operation | Checkmark animation, green highlight |
| **Disabled state** | Non-interactive element | Reduced opacity (`0.38`-`0.5`), no pointer |
| **Optimistic state** | UI updates before server confirms | Instant update, rollback on failure |
| **Focus state** | Element is keyboard-focused | Visible ring/outline, `:focus-visible` |
| **Active state** | Element is being pressed/tapped | Scale-down, background darken |

### Video Composition Quick Reference

| Aspect Ratio | Use Case | Resolution (common) | FPS |
|:---|:---|:---|:---|
| **9:16** | TikTok, Reels, Shorts, Stories | 1080×1920 | 30 or 60 |
| **16:9** | YouTube, landscape video | 1920×1080, 3840×2160 | 24, 30, or 60 |
| **1:1** | Square social posts | 1080×1080 | 30 |
| **4:5** | Instagram portrait post | 1080×1350 | 30 |
| **21:9** | Cinematic / ultrawide | 3840×1620 | 24 or 30 |

---

## Code Implementation Examples

### Remotion Hook Timing and Interpolation (React)

```typescript
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import React from 'react';

export const KineticTitle: React.FC<{ text: string }> = ({ text }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // 1. Spring scale-in with a slight bounce (damping: 12)
  const scale = spring({
    frame,
    fps,
    config: { damping: 12, mass: 0.5, stiffness: 100 },
  });

  // 2. Linear opacity mapping: frames [0-15] -> [0-1]
  const opacity = interpolate(frame, [0, 15], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // 3. Ken Burns Pan mapping: frames [0-120] -> [0px to -50px]
  const translateX = interpolate(frame, [0, 120], [0, -50]);

  return (
    <h1 style={{
      opacity,
      transform: `scale(${scale}) translateX(${translateX}px)`,
      fontFamily: 'Inter, sans-serif',
      color: '#ffffff',
    }}>
      {text}
    </h1>
  );
};
```

### Framer Motion — Staggered Entrance + Shared Element

```tsx
import { motion, AnimatePresence } from 'framer-motion';

const container = {
  hidden: {},
  show: { transition: { staggerChildren: 0.08 } },
};

const item = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0, transition: { ease: 'easeOut', duration: 0.35 } },
};

function ItemList({ items, onSelect }: Props) {
  return (
    <motion.ul variants={container} initial="hidden" animate="show">
      <AnimatePresence>
        {items.map(item => (
          <motion.li
            key={item.id}
            variants={item}
            layoutId={`item-${item.id}`}
            exit={{ opacity: 0, scale: 0.95 }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            {item.name}
          </motion.li>
        ))}
      </AnimatePresence>
    </motion.ul>
  );
}
```

### React Native Reanimated — Spring-based Drag-to-Dismiss

```tsx
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  runOnJS,
} from 'react-native-reanimated';
import { Gesture, GestureDetector } from 'react-native-gesture-handler';

function SwipeableCard({ children, onDismiss }) {
  const translateX = useSharedValue(0);
  const context = useSharedValue({ x: 0 });

  const gesture = Gesture.Pan()
    .onStart(() => { context.value = { x: translateX.value }; })
    .onUpdate((e) => {
      translateX.value = context.value.x + e.translationX;
    })
    .onEnd(() => {
      if (Math.abs(translateX.value) > 100) {
        runOnJS(onDismiss)();
      }
      translateX.value = withSpring(0, { damping: 20, stiffness: 200 });
    });

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: translateX.value }],
  }));

  return (
    <GestureDetector gesture={gesture}>
      <Animated.View style={animatedStyle}>{children}</Animated.View>
    </GestureDetector>
  );
}
```

### Hyperframe Scene Structuring (HTML)

```html
<!-- Main Composition viewport -->
<div class="composition" style="width: 1080px; height: 1920px; position: relative; overflow: hidden;">
  
  <!-- Scene 1: Background Ken Burns & Logo (Starts at frame 0, runs 90 frames) -->
  <div data-start="0" data-duration="90" class="sequence absolute-fill">
    <div class="ken-burns-bg absolute-fill" style="background-image: url('bg.jpg');"></div>
    <div class="logo-pop-in" style="transform-origin: center;">Logo</div>
  </div>

  <!-- Scene 2: Text Morph & Staggered Points (Starts at frame 90, runs 120 frames) -->
  <div data-start="90" data-duration="120" class="sequence absolute-fill">
    <div class="morph-text-container">
      <span class="morph-word" style="--delay: 0;">Learn</span>
      <span class="morph-word" style="--delay: 1;">Build</span>
      <span class="morph-word" style="--delay: 2;">Share</span>
    </div>
  </div>
</div>
```

### CSS — Reduced Motion Respect

```css
/* Default: full animation */
.hero-title {
  transition: transform 400ms cubic-bezier(0, 0, 0.2, 1), opacity 400ms ease-out;
}

/* Reduced motion: fade only, no movement */
@media (prefers-reduced-motion: reduce) {
  .hero-title {
    transition: opacity 300ms ease-out;
    transform: none !important;
  }
  
  /* Disable parallax, shimmer, and decorative animations */
  .parallax-layer,
  .shimmer-overlay {
    animation: none !important;
    transition: none !important;
  }
}
```

---

## Common Pitfalls & Troubleshooting

| Mistake / Issue | How to Detect | Remediation / Fix |
|:---|:---|:---|
| **Non-deterministic rendering (video)** | Video timings change/drift on re-render; audio desyncs | Do NOT use `Date.now()`, `Math.random()` (unseeded), `setTimeout`, `setInterval`, CSS transitions, or CSS animation delays. Bind all timing to `useCurrentFrame()` (Remotion) or frame-indexed data attributes (Hyperframe). |
| **Asset loading pop-in (flicker)** | Media/images/fonts are blank for first few frames | Preload all assets. In Remotion, use `delayRender()` + `continueRender()`. Preload fonts with `<link rel="preload">`. |
| **Audio drifting** | Speech/audio misaligns with visuals | Ensure audio track starts at exact target frame offset. Coordinate visual keyframes with waveform timestamps. |
| **Layout thrashing (jank)** | Frame generation is slow; dropped frames in preview | NEVER animate `width`, `height`, `top`, `left`, `margin`, `padding`. Use only `transform` (translate, scale, rotate) and `opacity`. |
| **Forgetting reduced motion** | Animations cause discomfort; fails a11y audits | Wrap decorative animations in `@media (prefers-reduced-motion: reduce)`. Provide `reducedMotion` prop. Use `useReducedMotion()` (Framer Motion) or `AccessibilityInfo.isReduceMotionEnabled()` (React Native). |
| **Wrong easing for the context** | Animation feels sluggish or jarring | Micro-interactions → ease-out (fast start). Exits → ease-in (fast end). Page transitions → ease-in-out. Playful → spring. |
| **Over-animating** | UI feels slow or dizzying | Limit animation duration: micro-interactions 100-250ms, surface entrances 200-400ms, page transitions 250-500ms. Not every element needs animation. |
| **Stagger too fast or too slow** | Items appear together or take too long | List items: 50-80ms stagger. Feature cards: 100-150ms stagger. Total stagger should not exceed 500ms for a full view. |
| **Missing state handling** | No loading/error/empty states for animated UIs | Always define loading → success, loading → error, loading → empty transitions. Use `AnimatePresence` (Framer Motion) or `LayoutAnimation` (RN) for mount/unmount. |
| **CLS from entrance animations** | Content shifts after animation completes | Animate from `transform: scale(0.95)` (not shrinking the element). Use `opacity` + `transform`. Never animate `width`/`height` that would change layout. |

For detailed guidance on any of the above topics, see the modular reference files:
- [Easing curves deep-dive](references/easing-curves-guide.md)
- [UI/UX vocabulary & patterns](references/ui-ux-vocabulary.md)
- [Video production terminology](references/video-production-basics.md)
- [Example usage patterns](examples/animation-request-patterns.md)

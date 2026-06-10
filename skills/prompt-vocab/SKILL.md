---
name: prompt-vocab
description: A glossary and execution guide for using common animation, UI design, and motion video vocabulary to describe UX transitions, feedback, layouts, and programmatic video creation.
---

# Animation, UI Design & Motion Video Vocabulary Guide

This skill serves as a standard dictionary and guide for animation, UI design, and video-as-code terms. It ensures precise communication when designing, coding, or prompting UI layouts, components, transitions, gestures, and programmatic video animations.

## Overview
When designing or implementing modern, premium web applications and programmatic motion videos (e.g. using Remotion or Hyperframe), visual hierarchy, consistent component architecture, and high-quality motion are essential. This document defines the terminology for animations, UI components, and video-as-code timings to describe visual layouts and motion scripts accurately.

## Trigger Conditions
Use this skill when:
- Designing or implementing layouts, component architecture, or navigation patterns.
- Working on styling, layout transitions, or custom animations in CSS, JS, Framer Motion, React Native, etc.
- Writing programmatic motion videos, dynamic slideshows, video intros, or kinetic typography.
- Working with video-as-code frameworks such as **Remotion** (React-based) or **Hyperframe** (HTML-based).
- Specifying timing, sequence overlaps, camera movements, audio sync, or video rendering pipelines.

---

## Step-by-Step Execution Guide

### Step 1: Identify the Component, Video Structure & Timeline
Determine the structural classification of the request:
1. **App/Web Surface**: Is it a card, modal, sheet, sidebar, or popover?
2. **Video Composition**: What is the target resolution (e.g., 1080x1920 for shorts, 1920x1080 for landscape), frame rate (e.g., 30fps or 60fps), and duration?
3. **Sequencing**: How do elements overlap? Define scene durations and stagger delays.

### Step 2: Choose the Philosophy & Framework
Align with the target system:
- **Material Design / Apple HIG / Radix UI**: For UI styling and interaction rules.
- **Remotion (React)**: For data-driven, modular React component videos leveraging state hooks, `interpolate`, and programmatic spring models.
- **Hyperframe (HTML/CSS/JS)**: For agent-native, DOM-lightweight HTML videos using timeline data attributes (`data-start`, `data-duration`) and libraries like GSAP or Anime.js.

### Step 3: Match the Timing and Motion
Select correct animation and video vocabulary (e.g., *pop in*, *kinetic text reveal*, *shimmer*, *parallax scroll*, *crossfade transition*).

### Step 4: Implement Safely & Deterministically
1. **Deterministic Timing**: In videos, never use `setTimeout`, `setInterval`, or CSS animations with standard wall-clock time (`1s`, `200ms`). Timing MUST be bound to the exact **Frame Number** (e.g., using Remotion's `useCurrentFrame()` hook or GSAP timeline seek offsets) to guarantee identical output rendering on any machine.
2. **Compositing**: Avoid animating layout properties (`width`, `height`, etc.) which trigger layout thrashing and lower rendering performance. Prefer `transform` and `opacity`.
3. **Reduced Motion**: Provide safe styling fallbacks for standard web components using `@media (prefers-reduced-motion: reduce)`.

---

## Glossary of Motion Video & Video-as-Code

### 1. Core Video-as-Code Concepts
- **Composition**: The root wrapper defining video metadata (width, height, FPS, duration in frames) and mounting the main video component.
- **Frame-based Timing**: Timing driven by frame index (0, 1, 2...) instead of time in milliseconds, ensuring deterministic, reproducible rendering.
- **Sequence**: A timeline layer or time-window utility that mounts, plays, and unmounts child components at designated frame intervals (e.g., starting at frame 30 for 90 frames duration).
- **AbsoluteFill**: A layout helper that absolutely positions a container to occupy the exact dimensions of the composition.
- **Interpolate / Interpolation**: Mapping a frame range to a style range (e.g. mapping frames 0-30 to scale values 0-1).
- **Deterministic Rendering**: The concept that compiling a video from code produces the exact same sequence of pixel-perfect frames regardless of host hardware, CPU load, or network delay.
- **Headless Browser Rendering**: Launching a browser programmatically (e.g. Puppeteer/Chromium) to capture individual webpage frames as PNGs, then stitching them together using FFmpeg to output an MP4.

### 2. Kinetic Typography & Text Effects
- **Text Reveal (Character/Word-by-word)**: Animating words or letters individually into view using an entry effect (slide, scale, or fade) with staggered offsets.
- **Text Sweep / Shimmer**: A reflective light bar moving across characters to create a premium, metallic look.
- **Typewriter**: A classic sequential letter-by-letter reveal, often paired with sound effects synchronized to the frame intervals.
- **Text Morph / Transition**: Characters smoothly changing shape or position to morph into another word (e.g. changing numbers rolling up).

### 3. Camera & Scene Manipulation
- **Parallax Layers (Background, Midground, Foreground)**: Moving background elements slower than foreground elements to simulate a 3D depth of field in a 2D camera view.
- **Ken Burns Effect**: A slow, smooth pan and zoom across a static image or background asset to create active visual interest.
- **Camera Shake / Earthquake**: Rapid, random translation offset values to simulate camera vibration during impacts, explosions, or beats.
- **3D Space / Perspective Flip**: Rotating the entire scene or card container in 3D (`rotateX`, `rotateY`, `translateZ`) with a defined perspective height.

### 4. Audio Syncing & Transitions
- **Audio Waveform Visualizer**: Animating component sizes or drawing heights dynamically based on audio amplitude values mapped frame-by-frame.
- **Beat-sync / Pulsing**: Scaling or vibrating elements precisely at audio peak frames.
- **Crossfade Transition**: Smoothly fading out one video sequence while fading in the next.
- **Match Cut**: Transitioning scenes by aligning matching shapes, colors, or actions between the last frame of scene A and first frame of scene B.

---

## Glossary of UI Design & Component Systems

### 1. Design System Architectures
- **Design Tokens**: Core variables (colors, spacing, typography, shadows) serving as a single source of truth for visual styles.
- **Atomic Design**: Hierarchy methodology classifying UI into:
  - **Atoms** (Buttons, Icons) -> **Molecules** (Search bar) -> **Organisms** (Headers) -> **Templates** -> **Pages**.
- **Headless UI / Primitives**: Unstyled components providing accessibility logic (ARIA states, keyboard focus) without opinionated visual styling (e.g., Radix UI).

### 2. Layout & Surfaces
- **Card (Elevated, Outlined, Filled)**: A content container presenting related information.
- **Dialog / Modal**: An overlay window that sits on top of the main page and intercepts user interaction.
- **Sheet / Drawer**: A panel that slides out from the edge of the screen (side or bottom).
- **Popover**: A lightweight, contextual panel anchored next to its trigger element.
- **Accordion / Collapsible**: A vertically stacked list of headers that expand to reveal or hide content.

### 3. Navigation Controls
- **Segmented Control**: A horizontal selector of two or more buttons, functioning as a single-select tab bar (common in Apple HIG).
- **Navigation Drawer / Sidebar / Rail**: Vertical structures containing top-level navigation links.
- **Breadcrumbs**: A row of links showing the current page's position in the site's folder hierarchy.

---

## Glossary of Animation Vocabulary

### 1. Entrances & Exits
- **Fade in / Fade out**: Element appears or disappears by changing opacity.
- **Slide in**: Element enters by sliding in from off-screen (left, right, top, or bottom).
- **Scale in**: Element grows from smaller to full size as it appears, often paired with a fade.
- **Pop in**: Element appears with a slight overshoot, like it bounces into place.
- **Reveal**: Content is uncovered gradually, often by animating a `clip-path` or mask.
- **Enter / Exit**: The animation an element plays when it’s added to or removed from the screen.

### 2. Sequencing & Easing
- **Keyframes / Interpolation**: Defining start, mid, and end frames and computing continuous values in between.
- **Stagger / Orchestration**: Animating several items one after another with small, coordinated delays.
- **Ease-out**: Starts fast, ends slow (default for UI).
- **Asymmetric Easing**: Acceleration and deceleration curves that are not mirror images, creating a more organic feel.
- **Spring (Tension, Damping, Mass)**: Physics-based movement driving natural velocity, bounce, and interruptible momentum.

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

### Hyperframe Scene Structuring (HTML Schema)
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

---

## Common Pitfalls & Troubleshooting

| Mistake / Issue | How to Detect | Remediation / Fix |
|:---|:---|:---|
| **Non-Deterministic Rendering** | Video visual timings change or drift on repeated rendering; audio becomes unsynced. | Do NOT use `Date.now()`, `Math.random()` (without a seed), `setTimeout`, `setInterval`, CSS transitions (`transition: all 0.3s`), or CSS animation delays. You **must** bind all animations directly to the current frame number (`useCurrentFrame()`). |
| **Asset Loading Pop-in (Flicker)** | Media, images, or custom fonts are empty for the first few frames, causing a visual flash. | Ensure all media assets are preloaded before rendering starts. In Remotion, use `delayRender()` and `continueRender()` handles. |
| **Audio Drifting** | Speech or audio elements drift away from mouth movement or text typography beats. | Ensure audio track starts exactly aligned on target frame offsets and coordinate visual animation keyframes with audio waveform timestamps. |
| **Layout Thrashing (Jank)** | Frame generation is slow (causing rendering times to spike), or dropped frames show in previews. | Avoid mutating layout properties (top, left, width, height) inside frame calculations. Always stick to hardware-accelerated transforms (`translate`, `scale`, `rotate`) and `opacity`. |
| **Missing Design Tokens** | Video visuals clash with the parent web application's styling. | Share variables (JSON/CSS Variables) containing the design tokens for color, typography, and shadow properties between the app codebase and video components. |

# UI/UX Vocabulary & Patterns Deep Reference

This reference provides detailed definitions and implementation guidance for UI/UX patterns referenced in the main `SKILL.md`. Use this when you need specific vocabulary for implementing responsive layouts, accessible interfaces, state-dependent UIs, or gesture-driven interactions.

---

## 1. Responsive Design Patterns

### Terminology

| Term | Definition | Implementation |
|:---|:---|:---|
| **Breakpoint** | A viewport width threshold where layout changes | CSS `@media (min-width: 768px)` |
| **Fluid grid** | Columns sized in relative units (%, fr, vw) rather than fixed pixels | CSS Grid (`grid-template-columns: repeat(auto-fill, minmax(250px, 1fr))`) |
| **Container query** | Layout adaptation based on container width, not viewport | CSS `@container (min-width: 400px)` |
| **Clamp()** | Fluid sizing between min, preferred, and max values | `font-size: clamp(1rem, 2.5vw, 2rem)` |
| **Mobile-first** | Design base styles for small screens, then enhance upward | `min-width` breakpoints in `@media` queries |
| **Stack / Unstack** | Elements stack vertically on mobile, become side-by-side on desktop | `flex-direction: column` → `flex-direction: row` |

### Responsive Pattern Decision Matrix

| Pattern | When to Use | CSS Technique |
|:---|:---|:---|
| **Mostly fluid** | Content-heavy pages (blogs, docs) | Min-widths, flexible widths, max-width container |
| **Column drop** | Multi-column → single column stacking | Flexbox with `flex-wrap` + `flex-basis` |
| **Layout shifter** | Major rearrangement at breakpoints (complex dashboards) | CSS Grid `grid-template-areas` reordering |
| **Off-canvas** | Navigation hides off-screen on mobile, visible on desktop | `translateX(-100%)` on mobile → `translateX(0)` on desktop |

### Common Breakpoints (Mobile-First)
```css
/* Base: mobile (320px+) */
/* No media query needed */

/* Tablet: 768px+ */
@media (min-width: 768px) { }

/* Desktop: 1024px+ */
@media (min-width: 1024px) { }

/* Wide: 1440px+ */
@media (min-width: 1440px) { }
```

---

## 2. Accessibility Vocabulary

### WCAG Success Criteria Relevant to Animation

| Criterion | Level | Requirement | Implementation |
|:---|:---|:---|:---|
| **2.2.2 Pause, Stop, Hide** | A | Moving/blinking content must have pause/stop/hide control | Pause button for auto-advancing carousels; `animation-play-state: paused` |
| **2.3.1 Three Flashes or Below** | A | No content flashes more than 3 times per second | Avoid rapid strobe effects; use safe animation frequencies |
| **2.3.3 Animation from Interactions** | AAA | Motion animations triggered by interaction can be disabled | Respect `prefers-reduced-motion`; provide a toggle |

### ARIA Attributes for Animated Components

| ARIA Attribute | Usage | Example |
|:---|:---|:---|
| `aria-live="polite"` | Content updates dynamically without user action | Toast notifications, live search results |
| `aria-live="assertive"` | Urgent content updates | Error banners, critical alerts |
| `aria-busy="true"` | Content is loading or animating | Skeleton screens, loading spinners |
| `aria-hidden="true"` | Element is temporarily hidden by animation | Closed accordion panels, dismissed modals |
| `role="alert"` | Important, time-sensitive information | Error messages, success confirmations |
| `role="status"` | Live region for non-critical updates | Loading progress, completion status |

### Accessibility Implementation Patterns

**Reduced Motion — CSS approach:**
```css
/* All decorative animations wrapped in no-preference */
@media (prefers-reduced-motion: no-preference) {
  .hero-reveal {
    animation: slideUp 600ms cubic-bezier(0.4, 0, 0.2, 1);
  }
  .shimmer {
    animation: shimmer 2s infinite;
  }
}

/* Reduced motion: only essential transitions remain */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

**Reduced Motion — Framer Motion:**
```tsx
import { useReducedMotion, motion } from 'framer-motion';

function HeroSection() {
  const prefersReducedMotion = useReducedMotion();

  return (
    <motion.div
      initial={prefersReducedMotion ? {} : { opacity: 0, y: 30 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: prefersReducedMotion ? 0 : 0.5 }}
    >
      Content
    </motion.div>
  );
}
```

**Reduced Motion — React Native:**
```tsx
import { AccessibilityInfo } from 'react-native';
import { useEffect, useState } from 'react';

function useReducedMotion() {
  const [reducedMotion, setReducedMotion] = useState(false);
  useEffect(() => {
    AccessibilityInfo.isReduceMotionEnabled().then(setReducedMotion);
    const sub = AccessibilityInfo.addEventListener(
      'reduceMotionChanged',
      setReducedMotion
    );
    return () => sub.remove();
  }, []);
  return reducedMotion;
}
```

---

## 3. State Patterns

### The Four Essential UI States

Every interactive component should handle these four states:

| State | Definition | When to Show | Visual Pattern |
|:---|:---|:---|:---|
| **Loading** | Content is being fetched or computed | Initial render, after refresh | Skeleton screen, shimmer, spinner with `aria-busy="true"` |
| **Empty** | No data exists yet | First visit, after clearing data, no results | Illustration + message + action button |
| **Error** | An operation failed | Network failure, server error, validation failure | Inline error, toast, banner with retry action |
| **Success** | Operation completed successfully | After data mutation, form submission | Checkmark, confirmation message, auto-dismissing toast |

### Animation Transitions Between States

```tsx
// Framer Motion — state transitions with AnimatePresence
function AsyncContent() {
  const { state, data, error, retry } = useAsyncData();

  return (
    <AnimatePresence mode="wait">
      {state === 'loading' && (
        <motion.div
          key="loading"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
        >
          <Skeleton />
        </motion.div>
      )}
      {state === 'error' && (
        <motion.div
          key="error"
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0 }}
        >
          <ErrorState message={error} onRetry={retry} />
        </motion.div>
      )}
      {state === 'success' && (
        <motion.div
          key="success"
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
        >
          <DataView data={data} />
        </motion.div>
      )}
    </AnimatePresence>
  );
}
```

### Skeleton Loading Vocabulary

| Pattern | What It Shows | Best For |
|:---|:---|:---|
| **Rectangle skeleton** | Gray rectangle with shimmer animation | Images, cards, banners |
| **Text skeleton** | Multiple lines of varying width | Article text, descriptions |
| **Circle skeleton** | Circular gray placeholder | Avatars, profile pictures |
| **Table skeleton** | Row × column grid of rectangles | Data tables, lists |
| **Pulse** | Fading opacity loop | Minimal loading, inline elements |

---

## 4. Micro-interactions

### Anatomy of a Micro-interaction

Every micro-interaction has four parts:
```
[Trigger] → [Rule] → [Feedback] → [Loop/Modes]
```

| Component | Definition | Example |
|:---|:---|:---|
| **Trigger** | What starts the interaction | User taps a button, hovers over a card |
| **Rule** | What determines the behavior | Button scales to 0.96 on press, returns to 1.0 on release |
| **Feedback** | What the user sees/hears/feels | Scale animation, haptic feedback, color change |
| **Loop/Modes** | How it behaves over time or in different states | Toggle stays in "on" position until tapped again |

### Common Micro-interaction Patterns

| Interaction | Trigger | Feedback | Duration | Implementation |
|:---|:---|:---|:---|:---|
| **Button press** | Touch `:active` / `whileTap` | Scale 0.96, background darken 10% | 100-150ms | `transform: scale(0.96)` + transition |
| **Hover lift** | Mouse hover `:hover` / `whileHover` | Scale 1.02, shadow elevation +2 | 200-300ms | `box-shadow` + `transform` transition |
| **Toggle switch** | Tap on switch | Knob slides, track color changes | 200-300ms | Spring physics, `translateX` |
| **Input focus** | Focus into text field | Border color change, subtle scale | 150-200ms | `outline`/`border-color` transition |
| **Drag-to-dismiss** | Pan gesture on card | Card follows finger, opacity decreases | Physics-based | Spring with `withSpring` or `useSpring` |
| **Pull-to-refresh** | Overscroll from top | Spinner appears, content bounces back | 300-500ms | Spring with resistance, threshold check |

---

## 5. Gesture Vocabulary

| Gesture | Definition | Common Use Cases | Key Property |
|:---|:---|:---|:---|
| **Tap** | Quick touch and release | Button press, link navigation | `whileTap`, `onTap` |
| **Long press** | Touch held for ~500ms | Context menu, reorder mode, delete | `onLongPress`, press duration threshold |
| **Swipe** | Horizontal or vertical flick | Dismiss card, navigate tabs, reveal actions | `translateX`, velocity-based spring |
| **Pan** | Continuous drag in any direction | Drawer open/close, slider, drag-and-drop | `translateX`/`translateY` tied to gesture delta |
| **Pinch** | Two-finger pinch in/out | Image zoom, map zoom, photo resize | `scale` tied to distance between two touch points |
| **Rotate** | Two-finger rotation | Image rotate, dial control | `rotate` tied to angle between touch points |
| **Double tap** | Two quick taps | Zoom to fit, like/heart | Tap interval < 300ms |
| **Pull to refresh** | Overscroll from top of scrollable content | Refresh feed, reload data | Scroll offset < 0 (overscroll), spring snap |
| **Overscroll** | Scroll beyond content bounds | Rubber-band effect, scroll-based parallax | `scrollTop` < 0 or > `scrollHeight` |

---

## 6. Design System Architecture

### Atomic Design Hierarchy

A methodology for classifying UI components by their level of composition:

| Level | Definition | Example |
|:---|:---|:---|
| **Atoms** | Smallest, indivisible UI elements | Button, Input, Icon, Label, Color swatch |
| **Molecules** | Groups of atoms functioning together | Search bar (Input + Button), Form field (Label + Input + Error) |
| **Organisms** | Complex sections combining molecules | Header (Logo + Nav + Search), Card (Image + Title + Actions) |
| **Templates** | Page-level wireframes placing organisms in a layout | Dashboard layout, Article page skeleton |
| **Pages** | Specific instances of templates with real content | User Dashboard, Blog Post |

### Design Tokens

| Token Type | Examples | Usage |
|:---|:---|:---|
| **Color** | `--color-primary: #6366f1`, `--color-surface: #ffffff` | Backgrounds, text, borders, accents |
| **Spacing** | `--space-xs: 4px`, `--space-md: 16px`, `--space-xl: 48px` | Margins, paddings, gaps |
| **Typography** | `--font-body: 16px/1.5 Inter`, `--font-heading: 700 32px/1.2` | Font sizes, weights, line heights |
| **Shadow / Elevation** | `--shadow-sm: 0 1px 3px rgba(0,0,0,0.1)` | Cards, modals, dropdowns |
| **Border radius** | `--radius-sm: 4px`, `--radius-md: 8px`, `--radius-full: 9999px` | Buttons, cards, avatars |
| **Duration** | `--duration-fast: 150ms`, `--duration-normal: 300ms` | Animation timing |
| **Easing** | `--ease-out: cubic-bezier(0, 0, 0.2, 1)` | Animation curves |

```css
/* Design tokens as CSS custom properties */
:root {
  --color-primary: #6366f1;
  --color-surface: #ffffff;
  --space-md: 16px;
  --font-body: 400 16px/1.5 'Inter', sans-serif;
  --radius-md: 8px;
  --duration-normal: 300ms;
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
}

.card {
  background: var(--color-surface);
  border-radius: var(--radius-md);
  padding: var(--space-md);
  transition: transform var(--duration-normal) var(--ease-out);
}
```

### Headless UI / Primitives

| Pattern | Definition | Libraries |
|:---|:---|:---|
| **Headless UI** | Unstyled components that provide behavior, accessibility, and state logic — no visual opinion | Radix UI, Reach UI, Headless UI (Tailwind), Ariakit |
| **Render props / Slot** | Pattern where the parent controls rendering while child provides state/behavior | `react-select`, downshift, `@radix-ui/react-popover` |
| **Compound component** | Parent and child components sharing implicit state via context | `<Select> <Select.Trigger> <Select.Option>` |
| **Polymorphic component** | Component that renders as a different HTML element via an `as` prop | `as="button"`, `as="a"`, `as={Link}` |

### Navigation Controls Vocabulary

| Component | Definition | Animation Pattern |
|:---|:---|:---|
| **Segmented control** | Horizontal single-select button group (Apple HIG) | Slide underline between segments; scale active segment text |
| **Tab bar** | Persistent bottom/top navigation tabs | Slide content panel; indicator underline slides |
| **Navigation drawer** | Side panel that slides in from left (mobile) | Slide in/out with overlay; often a sheet |
| **Sidebar / Rail** | Persistent vertical navigation on desktop | Collapsible: width animates, icons remain |
| **Breadcrumbs** | Row of links showing current page hierarchy | Slide text in/out on deeper navigation |
| **Stepper / Progress steps** | Sequential step indicator (e.g., checkout) | Checkmark entrance step completion; progress bar fill |
| **Bottom navigation** | Mobile bottom tab bar | Icon morphs between outlined → filled on selection |

---

## 7. Motion Choreography

### FLIP Technique (First, Last, Invert, Play)

Used for animating elements that change position/size between layout states:

1. **First** — Record element's starting position and size (`getBoundingClientRect()`)
2. **Last** — Apply layout change, record final position
3. **Invert** — Calculate the delta, apply `transform: translate(dx, dy) scale(dx/width)`
4. **Play** — Animate transform to `translate(0, 0) scale(1, 1)`

```typescript
function useFLIP(ref: RefObject<HTMLElement>, deps: any[]) {
  // Stores the "First" rect
  const firstRect = useRef<DOMRect | null>(null);

  useEffect(() => {
    if (!ref.current) return;

    if (!firstRect.current) {
      firstRect.current = ref.current.getBoundingClientRect();
      return;
    }

    const first = firstRect.current;
    const last = ref.current.getBoundingClientRect();

    const dx = first.left - last.left;
    const dy = first.top - last.top;
    const sx = first.width / last.width;
    const sy = first.height / last.height;

    // Invert
    ref.current.style.transform = `translate(${dx}px, ${dy}px) scale(${sx}, ${sy})`;
    ref.current.style.transition = 'none';

    // Play — trigger animation on next frame
    requestAnimationFrame(() => {
      ref.current!.style.transition = 'transform 400ms cubic-bezier(0.4, 0, 0.2, 1)';
      ref.current!.style.transform = 'translate(0, 0) scale(1, 1)';
    });

    firstRect.current = last;
  }, deps);
}
```

**Framework-native alternatives:**
- **Framer Motion:** `<motion.div layoutId="unique-id">` — automatic FLIP
- **React Native Reanimated:** `sharedTransitionTag="unique-tag"` + `SharedTransition` config
- **CSS View Transitions API:** `document.startViewTransition(() => updateDOM())`

### Orchestrated Sequence Pattern

For choreographing multiple elements in sequence:

```tsx
// Framer Motion — variants with staggerChildren
const containerVariants = {
  hidden: {},
  visible: {
    transition: {
      staggerChildren: 0.08,
      delayChildren: 0.2,
    },
  },
};

const childVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { ease: [0.4, 0, 0.2, 1], duration: 0.4 },
  },
};

<motion.div variants={containerVariants} initial="hidden" animate="visible">
  {items.map(item => (
    <motion.div key={item.id} variants={childVariants}>
      {item.name}
    </motion.div>
  ))}
</motion.div>
```

### Layout Animation Vocabulary

| Term | Definition | Implementation |
|:---|:---|:---|
| **Layout animation** | Element animates to new position/size when siblings change | `layout` prop (Framer Motion), `LayoutAnimation.configureNext()` (RN) |
| **Shared element** | Element with same identity across screens morphs smoothly | `layoutId` (Framer Motion), `sharedTransitionTag` (Reanimated) |
| **Animated presence** | Element animates in/out when mounted/unmounted | `<AnimatePresence>` (Framer Motion), `exiting` (Reanimated) |
| **List reorder** | Items in a list animate positions when items are added/removed/reordered | `layout` prop + `layoutScroll` (Framer Motion), `reanimated-layout` |

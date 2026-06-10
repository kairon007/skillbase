# Easing Curves Reference Guide

A practical deep-dive into timing functions for UI animation and video motion. Use this reference when you need to select the exact easing curve for a specific animation context.

---

## 1. CSS Built-in Keywords

| Keyword | Cubic Bezier Equivalent | Character | Best For |
|:---|:---|:---|:---|
| `ease` | `cubic-bezier(0.25, 0.1, 0.25, 1)` | Slow start, fast middle, slow end | Generic CSS animations; default for `transition` |
| `ease-in` | `cubic-bezier(0.4, 0, 1, 1)` | Starts slow, accelerates | Exit animations, things leaving the screen |
| `ease-out` | `cubic-bezier(0, 0, 0.2, 1)` | Starts fast, decelerates | **Default for UI entrances** — buttons appearing, modals, cards |
| `ease-in-out` | `cubic-bezier(0.4, 0, 0.2, 1)` | Gradual start and end | Page transitions, route changes, shared elements |
| `linear` | `cubic-bezier(0, 0, 1, 1)` | Constant speed | Color transitions, opacity fades, progress bars |

## 2. Recommended Curves for UI Animation

### Standard Ease-Out (Material Default)
```
cubic-bezier(0.4, 0, 0.2, 1)
```
```css
.card-enter {
  transition: transform 300ms cubic-bezier(0.4, 0, 0.2, 1),
              opacity 300ms cubic-bezier(0.4, 0, 0.2, 1);
}
```
- **Use for:** Most UI entrances, surface appearing, standard Material Design
- **Character:** Natural deceleration, feels responsive
- **Framer Motion:** `transition: { ease: [0.4, 0, 0.2, 1] }`

### Emphasized Ease-Out (Hero / Large Element)
```
cubic-bezier(0, 0, 0.2, 1.25)
```
```css
.hero-enter {
  transition: transform 500ms cubic-bezier(0, 0, 0.2, 1.25);
}
```
- **Use for:** Hero animations, featured cards, emphasized entrances
- **Character:** Overshoots target slightly then settles — dramatic without being bouncy

### Sharp Ease-Out (Micro-interaction)
```
cubic-bezier(0.4, 0, 0.6, 1)
```
```css
.button-press {
  transition: transform 100ms cubic-bezier(0.4, 0, 0.6, 1);
}
.button-press:active {
  transform: scale(0.96);
}
```
- **Use for:** Button press, toggle switch, tap feedback
- **Character:** Very fast, subtle motion

### Standard Ease-In-Out (Page Transition)
```
cubic-bezier(0.4, 0, 0.2, 1)
```
```css
.page-transition {
  transition: opacity 350ms cubic-bezier(0.4, 0, 0.2, 1),
              transform 350ms cubic-bezier(0.4, 0, 0.2, 1);
}
```
- **Use for:** Route transitions, shared element animations, content crossfade
- **Character:** Smooth, neutral — doesn't draw attention to itself

## 3. Spring Physics (Framer Motion, Reanimated)

Springs use physical parameters instead of bezier curves. They produce more natural motion and are interruptible.

| Use Case | Stiffness | Damping | Mass | Character |
|:---|:---|:---|:---|:---|
| **Gentle UI bounce** | 170 | 20 | 1 | Soft, subtle bounce for list items |
| **Snappy toggle** | 200 | 12 | 0.5 | Quick, playful switch animation |
| **Drag-to-dismiss** | 300 | 30 | 1 | Stiff resistance, no bounce on return |
| **Hero entrance** | 100 | 10 | 1 | Dramatic bounce, attention-grabbing |
| **Subtle hover lift** | 250 | 15 | 0.8 | Light float effect |

```tsx
// Framer Motion
<motion.div
  animate={{ scale: 1 }}
  initial={{ scale: 0.9 }}
  transition={{ type: 'spring', stiffness: 200, damping: 12 }}
/>

// React Native Reanimated
const scale = useSharedValue(0.9);
scale.value = withSpring(1, { stiffness: 200, damping: 12 });
```

### Key Spring Properties Explained

| Property | Effect | Typical Range |
|:---|:---|:---|
| **Stiffness** | Higher = snappier, faster return to resting | 100 (gentle) - 300 (stiff) |
| **Damping** | Higher = less bounce, more friction | 5 (bouncy) - 30 (solid) |
| **Mass** | Higher = heavier, slower to start/stop | 0.5 (light) - 2 (heavy) |

**Rule of thumb:** `damping > stiffness / 10` → no visible bounce. `damping < stiffness / 10` → bounce visible.

## 4. Brand / Custom Curves

Some companies use proprietary curves as part of their design language:

| Brand | Curve | Character |
|:---|:---|:---|
| **Apple (iOS)** | `cubic-bezier(0.44, 0.10, 0.20, 0.95)` | Smooth, premium, slightly bouncy |
| **Material (M3)** | `cubic-bezier(0.2, 0, 0, 1)` | Fast acceleration, slow deceleration — very polished |
| **Airbnb** | `cubic-bezier(0.47, 0.05, 0.31, 0.98)` | Expressive but controlled |

```css
/* Apple-style ease */
.ios-entrance {
  transition: transform 400ms cubic-bezier(0.44, 0.10, 0.20, 0.95);
}

/* M3 ease */
.m3-entrance {
  transition: transform 300ms cubic-bezier(0.2, 0, 0, 1);
}
```

## 5. Quick Selection Guide

```
User says "make it feel..."
  ├── "snappy" / "responsive" → Ease-out (0, 0, 0.2, 1), 100-200ms
  ├── "smooth" / "polished" → Ease-in-out (0.4, 0, 0.2, 1), 300-400ms
  ├── "playful" / "fun" → Spring (stiffness: 200, damping: 12), bounce visible
  ├── "premium" / "luxury" → Apple curve (0.44, 0.10, 0.20, 0.95), 400-500ms
  ├── "dramatic" / "emphasized" → Emphasized ease-out (0, 0, 0.2, 1.25), 400-600ms
  ├── "natural" / "organic" → Spring (stiffness: 170, damping: 20), gentle bounce
  └── "bouncy" / "energetic" → Spring (stiffness: 100, damping: 5), lots of bounce
```

## 6. Code Snippets by Framework

### CSS
```css
.custom-ease {
  transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
}
```

### Framer Motion
```tsx
<motion.div
  animate={{ x: 100 }}
  transition={{
    type: 'tween',     // or 'spring'
    ease: [0.4, 0, 0.2, 1],
    duration: 0.35,
  }}
/>
```

### React Native Reanimated
```tsx
// With timing
animated.value = withTiming(target, {
  duration: 300,
  easing: Easing.bezier(0.4, 0, 0.2, 1),
});

// With spring
animated.value = withSpring(target, {
  damping: 20,
  stiffness: 170,
  mass: 1,
});
```

### GSAP
```javascript
gsap.to('.element', {
  x: 100,
  duration: 0.4,
  ease: 'power2.out',          // ease-out
  // ease: 'back.out(1.7)',    // overshoot
  // ease: 'elastic.out(1, 0.3)', // bounce
});
```

### Remotion
```typescript
const frame = useCurrentFrame();
const progress = spring({
  frame,
  fps,
  config: { damping: 12, mass: 0.5, stiffness: 100 },
});
// Remotion's spring() is deterministic — always produces same output for same frame
```

## 7. Antipatterns

| Mistake | Why | Fix |
|:---|:---|:---|
| Using `linear` for movement | Looks robotic and unnatural | Use `ease-out` for entrances, `ease-in-out` for transitions |
| Using `ease-in` for entrances | Feels sluggish because it starts slow | Entrances should start fast — use `ease-out` |
| Over-engineering curves | Custom bezier with no rationale adds inconsistency | Use standard curves unless there's a specific brand reason |
| Springs with no damping control | Unintentional bounce on every interaction | Default to `damping: 20` for subtle, `damping: 12` for playful |
| Mixing spring and tween in same sequence | Jarring feel when physics and time-based animations collide | Keep the same type within a single animation sequence |

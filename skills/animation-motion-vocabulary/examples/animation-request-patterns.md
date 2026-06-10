# Animation Request Patterns

This file shows how to use the vocabulary from this skill in practice. Each section shows how a vague request gets translated into precise, actionable animation instructions.

---

## Pattern 1: Button Micro-interaction

### Vague Request
> "Make the button feel better when I click it."

### Using the Vocabulary
| Aspect | Translation |
|:---|:---|
| **Animation type** | Micro-interaction (button press) |
| **Trigger** | `whileTap` / `:active` — on press |
| **Feedback** | Scale to 0.96, darken background 15% |
| **Duration** | 100ms |
| **Easing** | Ease-out (`cubic-bezier(0, 0, 0.2, 1)`) with spring physics for release |
| **Reduced motion** | Disable scale animation, keep color change only |

### Implementation
```css
.button {
  transition: transform 100ms cubic-bezier(0, 0, 0.2, 1),
              background-color 100ms ease-out;
}
.button:active {
  transform: scale(0.96);
  background-color: color-mix(in srgb, currentColor 15%, transparent);
}
/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  .button:active {
    transform: none;
  }
}
```

---

## Pattern 2: Card List with Staggered Entrance

### Vague Request
> "I want the cards to appear one after another nicely."

### Using the Vocabulary
| Aspect | Translation |
|:---|:---|
| **Animation type** | Staggered entrance (list items) |
| **Effect** | Each card slides up + fades in |
| **Stagger delay** | 80ms between cards |
| **Duration** | 350ms per card |
| **Easing** | Ease-out (`cubic-bezier(0, 0, 0.2, 1)`) |
| **From position** | `translateY(24px)` |
| **Reduced motion** | Skip stagger, show all at once with full opacity |

### Implementation
```tsx
const container = {
  hidden: {},
  visible: {
    transition: { staggerChildren: 0.08 },
  },
};

const card = {
  hidden: { opacity: 0, y: 24 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { ease: [0, 0, 0.2, 1], duration: 0.35 },
  },
};

<motion.ul variants={container} initial="hidden" animate="visible">
  {cards.map(card => (
    <motion.li key={card.id} variants={card}>
      <CardComponent data={card} />
    </motion.li>
  ))}
</motion.ul>
```

---

## Pattern 3: Bottom Sheet with Drag-to-Dismiss

### Vague Request
> "A bottom panel that slides up and can be swiped away."

### Using the Vocabulary
| Aspect | Translation |
|:---|:---|
| **Component** | Sheet / Drawer (bottom) |
| **Entrance** | Slide up — `translateY(100%)` → `translateY(0)` |
| **Exit** | Slide down — `translateY(0)` → `translateY(100%)` |
| **Duration** | 300ms entrance, physics-based dismissal |
| **Gesture** | Pan down — drag threshold at 30% of sheet height |
| **Easing** | Spring for drag release (`damping: 25, stiffness: 300`) |
| **Backdrop** | Fade in 0→0.5 opacity, taps dismiss |

### Implementation
```tsx
function BottomSheet({ isOpen, onClose, children }) {
  const y = useSharedValue(0);
  const sheetHeight = 400; // approximate

  const gesture = Gesture.Pan()
    .onUpdate(e => {
      y.value = Math.max(0, e.translationY);
    })
    .onEnd(e => {
      if (y.value > sheetHeight * 0.3 || e.velocityY > 500) {
        runOnJS(onClose)();
      } else {
        y.value = withSpring(0, { damping: 25, stiffness: 300 });
      }
    });

  const rStyle = useAnimatedStyle(() => ({
    transform: [{ translateY: y.value }],
  }));

  return (
    <AnimatedPresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
        >
          <Overlay onClick={onClose} />
          <GestureDetector gesture={gesture}>
            <Animated.View style={rStyle}>
              {children}
            </Animated.View>
          </GestureDetector>
        </motion.div>
      )}
    </AnimatedPresence>
  );
}
```

---

## Pattern 4: Loading → Content Transition

### Vague Request
> "Add some nice loading animations."

### Using the Vocabulary
| Aspect | Translation |
|:---|:---|
| **State transition** | Loading → Success (data arrives) |
| **Loading pattern** | Skeleton cards with shimmer |
| **Transition** | Content crossfade — skeleton fades out, content fades in with slight scale |
| **Duration** | 250ms transition |
| **Easing** | Ease-in-out for crossfade |
| **Reduced motion** | Instant swap, no shimmer |

### Implementation
```tsx
function AsyncDashboard() {
  const { isLoading, data } = useDashboardData();

  return (
    <AnimatePresence mode="wait">
      {isLoading ? (
        <motion.div
          key="loading"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0, transition: { duration: 0.15 } }}
        >
          <ShimmerSkeleton count={4} />
        </motion.div>
      ) : (
        <motion.div
          key="content"
          initial={{ opacity: 0, scale: 0.98 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ ease: [0.4, 0, 0.2, 1], duration: 0.3 }}
        >
          <DashboardContent data={data} />
        </motion.div>
      )}
    </AnimatePresence>
  );
}
```

---

## Pattern 5: Video Intro with Kinetic Typography

### Vague Request
> "Make a video intro with moving text."

### Using the Vocabulary
| Aspect | Translation |
|:---|:---|
| **Type** | Video composition (Remotion) |
| **Aspect ratio** | 9:16 (1080×1920) — Shorts format |
| **Duration** | 5 seconds = 150 frames @ 30fps |
| **Scene 1 (0-60f)** | Background Ken Burns on image + logo fade in |
| **Scene 2 (60-150f)** | Kinetic text reveal — words staggered, each slides up + fades |
| **Text reveal** | Character-by-character with 3-frame stagger between chars |
| **Easing** | Spring per character (gentle bounce, damping: 15, stiffness: 120) |
| **Audio** | Background music, beat-sync pulse on logo entrance at frame 15 |
| **Render** | H.264 MP4, 30fps, CRF 18 |

### Implementation
```tsx
export const IntroVideo: React.FC = () => {
  const frame = useCurrentFrame();

  return (
    <AbsoluteFill style={{ backgroundColor: '#0a0a0a' }}>
      {/* Scene 1: Logo Entrance (frames 0-60) */}
      <Sequence from={0} durationInFrames={60}>
        <KenBurnsBackground image={bgImage} />
        <LogoReveal />
      </Sequence>

      {/* Scene 2: Kinetic Text (frames 60-150) */}
      <Sequence from={60} durationInFrames={90}>
        <KineticTitle
          text="Build Something Great"
          startFrame={0}
          charStagger={3}
        />
      </Sequence>
    </AbsoluteFill>
  );
};
```

---

## Pattern 6: Page Transition with Shared Element

### Vague Request
> "Animate between the list and detail page smoothly."

### Using the Vocabulary
| Aspect | Translation |
|:---|:---|
| **Animation type** | Shared element / layout animation |
| **Route transition** | List → Detail |
| **Shared element** | Card thumbnail morphs into hero image |
| **Other elements** | Crossfade: list text → detail content |
| **Duration** | 400ms |
| **Easing** | Ease-in-out (`cubic-bezier(0.4, 0, 0.2, 1)`) |
| **Direction** | Forward (enter from right, exit to left) |

### Implementation
```tsx
// List page — card component
<motion.div
  layoutId={`card-${item.id}`}
  onClick={() => navigate(`/detail/${item.id}`)}
  whileHover={{ scale: 1.02 }}
>
  <motion.img
    layoutId={`image-${item.id}`}
    src={item.thumbnail}
  />
  <motion.h3 layoutId={`title-${item.id}`}>{item.title}</motion.h3>
</motion.div>

// Detail page — hero section
<motion.div layoutId={`card-${item.id}`}>
  <motion.img
    layoutId={`image-${item.id}`}
    src={item.image}
    style={{ width: '100%', height: 400, objectFit: 'cover' }}
  />
  <motion.h1 layoutId={`title-${item.id}`}>{item.title}</motion.h1>
</motion.div>
```

---

## Pattern 7: Asking for Animations — Prompt Templates

Use these templates when requesting animation work from the AI:

### For a Micro-interaction
> "Add a micro-interaction to the [component] — on [trigger], apply [feedback] with [easing] over [duration]."

### For a Staggered Entrance
> "Animate the [list/grid] with a staggered entrance — each item [effect], staggered by [delay], eased with [easing]."

### For a Shared Element Transition
> "Implement a shared element transition between [route A] and [route B] using [framework]. The shared element is [element]."

### For a Video Composition
> "Create a [duration] [aspect ratio] video composition. Scene 1: [description]. Scene 2: [description]. Render settings: [codec] [resolution] [fps]."

### For Easing Guidance
> "I want the animation to feel [feeling]. Which easing curve should I use for [component]?"

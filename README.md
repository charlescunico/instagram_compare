# Instagram followers and following comparison script

The script handles both Instagram JSON structures (the `following.json` top-level object vs the bare array in `followers_1.json`) and outputs two clearly labelled lists plus a summary.

**How to run it:**

```bash
ruby instagram_compare.rb                              # uses default filenames
ruby instagram_compare.rb following.json followers_1.json   # explicit paths
```

**Example output:**

```
────────────────────────────────────────────────────────────
 You follow them — they DON'T follow you back (3)
────────────────────────────────────────────────────────────
  @someuser
    https://www.instagram.com/someuser/
  ...

────────────────────────────────────────────────────────────
 They follow you — you DON'T follow them back (5)
────────────────────────────────────────────────────────────
  @anotheruser
    https://www.instagram.com/anotheruser/
  ...

────────────────────────────────────────────────────────────
 Summary
────────────────────────────────────────────────────────────
  Total following          : 300
  Total followers          : 250
  Not following you back   : 3
  You don't follow back    : 5
────────────────────────────────────────────────────────────
```

A few things worth noting:
- **Both lists are sorted alphabetically** by username for easy scanning.
- The script **auto-detects** the different JSON shapes Instagram uses for the two files, so it won't break if the structure varies slightly.
- You can pass **custom file paths** as arguments if your export files have different names.

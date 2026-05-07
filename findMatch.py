from rapidfuzz import fuzz
import os

THRESHOLD = 80
OUTPUT_FILE = "cbz_duplicates.txt"

# Get all cbz files
files = [f for f in os.listdir(".") if f.lower().endswith(".cbz")]

results = []

for i in range(len(files)):
    for j in range(i + 1, len(files)):
        a = files[i]
        b = files[j]

        # compare filenames without extension
        name_a = os.path.splitext(a)[0]
        name_b = os.path.splitext(b)[0]

        score = fuzz.ratio(name_a.lower(), name_b.lower())

        if score >= THRESHOLD:
            results.append((score, a, b))

# Sort highest similarity first
results.sort(reverse=True)

# Write output file
with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    if not results:
        f.write("No similar CBZ files found.\n")
    else:
        for score, a, b in results:
            line = f"[{score}] {a}  <->  {b}\n"
            f.write(line)

print(f"Done. Results saved to {OUTPUT_FILE}")

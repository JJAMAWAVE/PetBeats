import re

# Read the file
with open(r'c:\PetBeats\lib\app\data\data_source\track_data.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Update remaining cat_noise tracks (04-07) - Medium/Large distribution
replacements = [
    (r"(cat_noise_04.*?tags: \[)'Cat'", r"\1'Medium Cat'"),
    (r"(cat_noise_05.*?tags: \[)'Cat'", r"\1'Medium Cat'"),
    (r"(cat_noise_06.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_noise_07.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    
    # Update all cat_energy tracks to 'Large Cat' (high energy)
    (r"(cat_energy_01.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_energy_02.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_energy_03.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_energy_04.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_energy_05.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_energy_06.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_energy_07.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_energy_08.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    
    # Update all cat_senior tracks to 'Large Cat' (senior care)
    (r"(cat_senior_01.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_senior_02.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_senior_03.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_senior_04.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_senior_05.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_senior_06.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_senior_07.*?tags: \[)'Cat'", r"\1'Large Cat'"),
    (r"(cat_senior_08.*?tags: \[)'Cat'", r"\1'Large Cat'"),
]

for pattern, replacement in replacements:
    content = re.sub(pattern, replacement, content, flags=re.DOTALL)

# Write back
with open(r'c:\PetBeats\lib\app\data\data_source\track_data.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated all remaining cat tracks with size categories")

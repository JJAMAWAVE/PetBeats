from twelvelabs import TwelveLabs

API_KEY = "tlk_1MYJ9F31G1EGRW25EG8SA0KT3742"
INDEX_ID = "693f77a5fa043d83a4908e5c"

KEYWORDS = [
    "elastic animation",
    "bouncy motion",
    "glassmorphism", 
    "transparent blur",
    "colorful gradient",
    "neon lights",
    "flat design",
    "3d interface"
]

def analyze_style():
    client = TwelveLabs(api_key=API_KEY)
    print(f"Analyzing Index ID: {INDEX_ID}")
    
    results = {}
    
    for kw in KEYWORDS:
        print(f"Searching for: '{kw}'...")
        try:
            matches = client.search.query(
                index_id=INDEX_ID,
                query_text=kw,
                search_options=["visual"]
            )
        except Exception as e:
            print(f"Search failed for '{kw}': {e}")
            continue
            
        # Get top match score
        data = list(matches)
        if data:
            top_score = data[0].score
            print(f"  -> Score: {top_score}")
            results[kw] = top_score
        else:
            print("  -> No match")
            results[kw] = 0.0

    print("\n--- Style Profile ---")
    sorted_res = sorted(results.items(), key=lambda x: x[1], reverse=True)
    for k, v in sorted_res:
        print(f"{k}: {v:.2f}")

if __name__ == "__main__":
    analyze_style()

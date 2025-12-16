from twelvelabs import TwelveLabs

API_KEY = "tlk_1MYJ9F31G1EGRW25EG8SA0KT3742"
VIDEO_ID = "693f77a68c5ff9ae4f60396f"

def get_analysis_v2():
    client = TwelveLabs(api_key=API_KEY)
    
    print(f"Generating summary for Video ID: {VIDEO_ID}...")
    try:
        # Based on inspection, client.generate is the method
        res = client.generate(
            video_id=VIDEO_ID,
            prompt="Describe the visual style of this video. Focus on motion (bouncy vs linear), colors (palette, gradients), and shapes (rounded, glassmorphism)."
        )
        print("\n--- Raw Response ---")
        print(res)
        
        print("\n--- Analysis Data ---")
        # Try to access data or content
        if hasattr(res, 'data'):
            print(res.data)
        elif hasattr(res, 'content'):
            print(res.content)
        else:
            print("Could not find data/content attribute. Check Raw Response.")

    except Exception as e:
        print(f"Generate failed: {e}")
        print(f"Type of error: {type(e)}")

if __name__ == "__main__":
    get_analysis_v2()

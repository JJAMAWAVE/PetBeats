from twelvelabs import TwelveLabs

API_KEY = "tlk_1MYJ9F31G1EGRW25EG8SA0KT3742"
INDEX_ID = "693f77a5fa043d83a4908e5c"

def main():
    client = TwelveLabs(api_key=API_KEY)
    
    print("1. Listing videos in index...")
    try:
        # Try both singular and plural access patterns for videos
        if hasattr(client.indexes, 'videos'):
             videos = client.indexes.videos.list(index_id=INDEX_ID)
        elif hasattr(client.index, 'videos'):
             videos = client.index.videos.list(index_id=INDEX_ID)
        else:
             print("Could not find videos capability on indexes.")
             return

        # Handle pagination or list return
        video_list = list(videos)
        if not video_list:
            print("No videos found in index.")
            return
            
        target_video = video_list[0]
        video_id = target_video.id
        print(f"Found Video ID: {video_id}")
        
        print("2. Generating Analysis...")
        # Try generate with correct method signature
        res = client.generate.text(
            video_id=video_id,
            prompt="Analyze the visual style of this video in detail. 1) Motion: Is it bouncy, elastic, linear, or ease-in-out? 2) Colors: What are the dominant colors and gradients? 3) Texture: Is it flat, glassmorphism, or neon? 4) Layout: How are elements arranged?"
        )
        print("\n--- Analysis Result ---")
        print(res.data)

    except Exception as e:
        print(f"Error: {e}")
        # Inspection fallback
        print("\n--- Debug Info ---")
        print(f"Dir client: {dir(client)}")
        if hasattr(client, 'generate'):
             print(f"Dir client.generate: {dir(client.generate)}")

if __name__ == "__main__":
    main()

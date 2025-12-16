import { TwelveLabs } from 'twelvelabs-js';
import dotenv from 'dotenv';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

// 환경 변수 설정
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
// .env 위치: c:\PetBeats\tools\mcp-twelvelabs\.env
dotenv.config({ path: path.resolve('c:/PetBeats/tools/mcp-twelvelabs/.env') });

const apiKey = process.env.TWELVELABS_API_KEY;
if (!apiKey) {
    console.error("Error: TWELVELABS_API_KEY not found.");
    process.exit(1);
}

const client = new TwelveLabs({ apiKey });

const VIDEO_PATH = 'c:/PetBeats/참조영상/Bento Grids_2.mp4';
const INDEX_NAME = 'PetBeats_Reference_Analysis';

async function main() {
    try {
        console.log(`1. Checking/Creating Index: ${INDEX_NAME}...`);
        let indexId;
        const indexes = await client.index.list();
        const existingIndex = indexes.data.find(i => i.name === INDEX_NAME);

        if (existingIndex) {
            indexId = existingIndex.id;
            console.log(`   Found existing index: ${indexId}`);
        } else {
            const newIndex = await client.index.create({
                name: INDEX_NAME,
                engines: [
                    { name: "marengo2.6", options: ["visual", "conversation", "text_in_video", "logo"] },
                    { name: "pegasus1.1", options: ["visual", "conversation"] }
                ]
            });
            indexId = newIndex.id;
            console.log(`   Created new index: ${indexId}`);
        }

        console.log(`2. Uploading video: ${VIDEO_PATH}...`);
        const task = await client.task.create({
            indexId: indexId,
            file: fs.createReadStream(VIDEO_PATH)
        });
        console.log(`   Task created: ${task.id}`);

        console.log(`3. Waiting for indexing to complete...`);
        let videoId;
        await new Promise((resolve, reject) => {
            const interval = setInterval(async () => {
                try {
                    const taskStatus = await client.task.retrieve(task.id);
                    console.log(`   Status: ${taskStatus.status} (${taskStatus.progress || 0}%)`);

                    if (taskStatus.status === 'ready') {
                        clearInterval(interval);
                        videoId = taskStatus.videoId;
                        resolve();
                    } else if (taskStatus.status === 'failed') {
                        clearInterval(interval);
                        reject(new Error(`Indexing failed: ${taskStatus.processStatus?.message}`));
                    }
                } catch (e) {
                    clearInterval(interval);
                    reject(e);
                }
            }, 2000); // 2초마다 확인
        });
        console.log(`   Indexing completed. Video ID: ${videoId}`);

        console.log(`4. Analyzing video (Generating text)...`);
        const prompt = "Describe the animation style, motion effects (like parallax, shimmer, easing), colors, and overall visual atmosphere in detail. Focus on the 'Bento' grid style.";

        const result = await client.generate.text({
            videoId: videoId,
            prompt: prompt
        });

        console.log("\n[Analysis Result]");
        console.log(result.data);

    } catch (error) {
        console.error("Error during analysis:", error);
    }
}

main();

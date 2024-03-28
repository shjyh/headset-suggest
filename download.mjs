// INSERT INTO `headphone` VALUES (8, 'test', '[\"1.jpg\"]', 'test', 1, 10.00, '[{\"key\":\"aa\",\"value\":\"bb\"}]', 0);

import fs from "node:fs/promises";
import axios from "axios";

function escapeJson(str) {
    return str.replace(/\\/g, "\\\\").replace(/"/g, "\\\"");
}

/**
 * 标注 productsJson类型
 * @type {typeof import("./products.json")}
 */
const productsJson = JSON.parse(await fs.readFile("./products.json", "utf-8"));

/**
 * 
 * @param {string} url 
 * @returns
 */
async function downloadFile(url) {
    const fileName = url.split("/").pop();
    const response = await axios({
        method: "GET",
        url,
        responseType: "arraybuffer",
        headers: {
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7",
            "Cache-Control": "no-cache",
            "Dnt": "1",
            "Pragma": "no-cache"
        }
    });

    await fs.writeFile("./public/assets/" + fileName, response.data);
    return fileName;
}

const sqls = [];

let currentIndex = 0;

try {
    for(let p of productsJson) {
        currentIndex ++;
        if(p.skip) continue;
        const images = [];
        const contents = [];
        for(let image of p.allImages) {
            images.push(await downloadFile(image));
        }
        for(let image of p.contentImage) {
            contents.push(await downloadFile(image));
        }

        sqls.push(`INSERT INTO \`headphone\` VALUES (${currentIndex}, '${p.title}', '${
            escapeJson(JSON.stringify(images))
        }', '${contents.join("\\n")}', 1, ${p.price.toFixed(2)}, '[{\"key\":\"brand\",\"value\":\"${p.brand}\"},{\"key\":\"model\",\"value\":\"${p.model}\"}]', 0);`)
        p.skip = true;
    }
    await fs.writeFile("./products.json", JSON.stringify(productsJson, null, 4), "utf-8");
} catch(e) {
    console.error(e);
}finally{
    await fs.writeFile("./product.sql", sqls.join("\n"));
}
import type { AstroGlobal } from "astro";
import axios from "axios";

const HOST = "http://localhost:8080";

function resolveUrl(url: string) {
    if(url.startsWith("http")) {
        const { pathname, search } = new URL(url);
        return resolveUrl(pathname + search);
    }

    if(url.startsWith("/api")) {
        return HOST + url.substring(4);
    }

    return HOST + url;
}

export async function pass(req: Request): Promise<Response> {
   
    
    const res = await axios.request({
        url: resolveUrl(req.url),
        method: req.method,
        data: await req.json(),
        headers: {
            "Cookie": req.headers.get("Cookie")
        },
        validateStatus: () => true
    });

    const resHeaders: any = {};

    for(let h of ["cache-control", "content-encoding", "content-type", "server", "set-cookie"]) {
        if(!res.headers[h]) continue;

        if(Array.isArray(res.headers[h])) {
            if(!res.headers[h][0]) continue;
            resHeaders[h] = res.headers[h][0];
        } else {
            resHeaders[h] = res.headers[h]
        }
    }

    const d = typeof res.data === "string" ? res.data : JSON.stringify(res.data);

    return new Response(d, {
        status: res.status,
        headers: resHeaders
    })
}

export async function go(request: Request, method: "GET" | "POST", url: string, body?: any): Promise<any> {

    const { data } = await axios.request({
        url: resolveUrl(url),
        method,
        headers: {
            "Cookie": request.headers.get("Cookie")
        },
        data: body
    });

    return data;
}
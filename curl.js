function $(selector) { return document.querySelector(selector); }
function $a(selector) { return document.querySelectorAll(selector); }
function $c(clazz) {
    return $("[class^=" + clazz + "]");
}
function $ac(clazz) {
    return $a("[class^=" + clazz + "]");
}

function $(selector) { return document.querySelector(selector); }
function $a(selector) { return document.querySelectorAll(selector); }

function run() {
    const title = $c("ItemHeader--mainTitle-").innerText;
    const price = Number.parseInt($c("Price--priceText-").innerText);

    const allImages = [...new Set(
        [...$ac("PicGallery--thumbnailPic-")].map(i => i.src)
    )].map(src => src.replace("110x10000", ""));

    const attrs = [
        ...$ac("Attrs--attr-")
    ]

    let brand = "";
    let model = "";

    for(let attr of attrs) {
        const v = attr.innerText;
        if(v.includes("品牌：")) {
            brand = v.split("品牌：")[1];
        }
        else if(v.includes("型号：")) {
            model = v.split("型号：")[1];
        }

        if(brand && model) {
            break;
        }
    }

    const contentImage = [...document.querySelectorAll(".desc-root img")]
        .map(n => n.dataset.src || n.src)
        .map(src => src.startsWith("//") ? ("https:" + src) : src)
    contentImage.pop();

    return {
        title, price, allImages, brand, model, contentImage
    }
}

copy(JSON.stringify(run(), null, 4));
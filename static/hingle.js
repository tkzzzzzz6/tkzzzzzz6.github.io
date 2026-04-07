/* ----

# Hingle Theme
# By: Dreamer-Paul
# Last Update: 2024.9.2

一个简洁大气，含夜间模式的 Hexo 博客模板。

本代码为奇趣保罗原创，并遵守 MIT 开源协议。欢迎访问我的博客：https://paugram.com

---- */

var Paul_Hingle = function (config) {
    var body = document.body;
    var content = ks.select(".post-content:not(.is-special), .page-content:not(.is-special)");
    var isProgrammaticCopy = false;

    // 菜单按钮
    this.header = function () {
        var menu = document.getElementsByClassName("head-menu")[0];

        ks.select(".toggle-btn").onclick = function () {
            menu.classList.toggle("active");
        };

        ks.select(".light-btn").onclick = this.night;

        var search = document.getElementsByClassName("search-btn")[0];
        var bar = document.getElementsByClassName("head-search")[0];

        search.addEventListener("click", function () {
            bar.classList.toggle("active");
        })
    };

    // 关灯切换
    this.night = function () {
        if(body.classList.contains("dark-theme")){
            body.classList.remove("dark-theme");
            document.cookie = "night=false;" + "path=/;" + "max-age=21600";
        }
        else{
            body.classList.add("dark-theme");
            document.cookie = "night=true;" + "path=/;" + "max-age=21600";
        }
    };

    // 目录树
    this.tree = function () {
        const wrap = ks.select(".wrap");
        const headings = content.querySelectorAll("h1, h2, h3, h4, h5, h6");

        if (headings.length === 0) {
            return;
        }

        body.classList.add("has-trees");

        // 计算数量，得出最高层级
        const levelCount = { h1: 0, h2: 0, h3: 0, h4: 0, h5: 0, h6: 0 };

        headings.forEach((el) => {
            const tagName = el.tagName.toLowerCase();
            levelCount[tagName]++;
        });

        let firstLevel = 1;
        if (levelCount.h1 === 0 && levelCount.h2 > 0) {
            firstLevel = 2;
        }
        else if (levelCount.h1 === 0 && levelCount.h2 === 0 && levelCount.h3 > 0) {
            firstLevel = 3;
        }

        // 目录树节点
        const trees = ks.create("section", {
            class: "article-list",
            html: `<h4><span class="title">目录</span></h4>`
        });

        ks.each(headings, (t, index) => {
            const text = t.innerText;

            t.id = "title-" + index;

            const level = Number(t.tagName.substring(1)) - firstLevel + 1;
            const className = `item-${level}`;

            trees.appendChild(ks.create("a", { class: className, text, href: `#title-${index}` }));
        });

        wrap.appendChild(trees);

        // 绑定元素
        const buttons = ks.select("footer .buttons");
        const btn = ks.create("button", {
            class: "toggle-list",
            attr: [
                {name: "title", value: "切换文章目录"},
            ],
        });
        buttons.appendChild(btn);

        btn.addEventListener("click", () => {
            trees.classList.toggle("active");
        });
    };

    // 自动添加外链
    this.links = function () {
        var l = content.getElementsByTagName("a");

        if(l){
            ks.each(l, function (t) {
                t.target = "_blank";
            });
        }
    };

    this.comment_list = function () {
        ks(".comment-content [href^='#comment']").each(function (t) {
            var item = ks.select(t.getAttribute("href"));

            t.onmouseover = function () {
                item.classList.add("active");
            };

            t.onmouseout = function () {
                item.classList.remove("active");
            };
        });
    };

    this.copy_code = function () {
        var root = content || document;
        var blocks = root.querySelectorAll("pre[class*='language-'], pre.line-numbers, figure.highlight pre, .highlight pre");

        var showToast = function (text, isError) {
            var oldToast = document.querySelector(".copy-toast");
            if(oldToast){
                oldToast.parentNode.removeChild(oldToast);
            }

            var toast = document.createElement("div");
            toast.className = "copy-toast" + (isError ? " error" : "");
            toast.textContent = text;
            document.body.appendChild(toast);

            requestAnimationFrame(function () {
                toast.classList.add("show");
            });

            setTimeout(function () {
                toast.classList.remove("show");
                setTimeout(function () {
                    if(toast.parentNode){
                        toast.parentNode.removeChild(toast);
                    }
                }, 180);
            }, 1600);
        };

        var copyText = function (text) {
            if(navigator.clipboard && window.isSecureContext){
                return navigator.clipboard.writeText(text);
            }

            return new Promise(function (resolve, reject) {
                var textarea = document.createElement("textarea");
                textarea.value = text;
                textarea.setAttribute("readonly", "readonly");
                textarea.style.position = "fixed";
                textarea.style.top = "-9999px";
                textarea.style.left = "-9999px";
                document.body.appendChild(textarea);
                textarea.focus();
                textarea.select();
                textarea.setSelectionRange(0, textarea.value.length);

                try{
                    if(document.execCommand("copy")){
                        resolve();
                    }
                    else{
                        reject(new Error("copy_failed"));
                    }
                }
                catch (err){
                    reject(err);
                }
                finally{
                    document.body.removeChild(textarea);
                }
            });
        };

        ks.each(blocks, function (pre) {
            if(pre.getAttribute("data-copy-ready") === "1"){
                return;
            }

            var code = pre.querySelector("code");
            if(!code){
                code = pre;
            }

            pre.setAttribute("data-copy-ready", "1");

            var block = pre.closest && pre.closest("figure.highlight") ? pre.closest("figure.highlight") : pre;
            var wrapper = block.parentNode;
            if(!wrapper.classList || !wrapper.classList.contains("code-copy-wrap")){
                wrapper = document.createElement("div");
                wrapper.className = "code-copy-wrap";
                block.parentNode.insertBefore(wrapper, block);
                wrapper.appendChild(block);
            }

            if(wrapper.querySelector(".code-copy-btn")){
                return;
            }

            var button = document.createElement("button");
            button.type = "button";
            button.className = "code-copy-btn";
            button.setAttribute("aria-label", "复制代码");
            button.textContent = "复制";
            wrapper.appendChild(button);

            var timer = null;
            var setButtonState = function (text, className) {
                if(timer){
                    clearTimeout(timer);
                }

                button.textContent = text;
                button.classList.remove("is-success", "is-error");
                if(className){
                    button.classList.add(className);
                }

                if(className){
                    timer = setTimeout(function () {
                        button.textContent = "复制";
                        button.classList.remove("is-success", "is-error");
                    }, 1600);
                }
            };

            button.addEventListener("click", function () {
                var text = code.textContent.replace(/\u00a0/g, " ").replace(/\n$/, "");

                if(!text){
                    setButtonState("无内容", "is-error");
                    showToast("代码块为空，无法复制", true);
                    return;
                }

                isProgrammaticCopy = true;
                var guardTimer = setTimeout(function () {
                    isProgrammaticCopy = false;
                }, 2000);
                copyText(text).then(function () {
                    setButtonState("已复制", "is-success");
                    showToast("代码已复制", false);
                }).catch(function () {
                    setButtonState("失败", "is-error");
                    showToast("复制失败，请手动复制", true);
                }).finally(function () {
                    clearTimeout(guardTimer);
                    setTimeout(function () {
                        isProgrammaticCopy = false;
                    }, 120);
                });
            });
        });
    };

    this.copy_notice = function () {
        if(!config.copyright){
            return;
        }

        document.oncopy = function () {
            if(isProgrammaticCopy){
                return;
            }

            ks.notice("感谢复制,希望内容对你有所帮助！", {color: "yellow", overlay: true, time: 2000});
        };
    };

    // 返回页首
    this.to_top = function () {
        var btn = document.getElementsByClassName("to-top")[0];
        var scroll = document.documentElement.scrollTop || document.body.scrollTop;

        scroll >= window.innerHeight / 2 ? btn.classList.add("active") : btn.classList.remove("active");
    };

    this.header();

    if(content){
        this.tree();
        this.links();
        this.comment_list();
    }
    this.copy_code();
    this.copy_notice();

    // 返回页首
    window.addEventListener("scroll", this.to_top);

    // 夜间模式初始化：先尊重用户上次选择，再考虑自动夜间策略
    var nightMatch = document.cookie.match(/(?:^|;\s*)night=(true|false)(?:;|$)/);

    if(nightMatch){
        if(nightMatch[1] === "true"){
            document.body.classList.add("dark-theme");
        }
        else{
            document.body.classList.remove("dark-theme");
        }
    }
    else if(config.night){
        var hour = new Date().getHours();

        if(hour <= 5 || hour >= 21){
            document.body.classList.add("dark-theme");
            document.cookie = "night=true;" + "path=/;" + "max-age=21600";
        }
    }

    //
    // ! Hexo 特别功能
    //

    // Hexo 百度搜索
    this.hexo_search = function () {
        var form = ks.select(".head-search"), input = ks.select(".head-search input");

        form.onsubmit = function (ev) {
            ev.preventDefault();

            var keyword = input.value.trim();
            if(!keyword){
                return;
            }

            var engine = (config.search_engine || "baidu").toLowerCase();
            var query = "site:" + location.host + " " + keyword;
            var url = "";

            if(engine === "google"){
                url = "https://www.google.com/search?q=" + encodeURIComponent(query);
            }
            else if(engine === "bing"){
                url = "https://www.bing.com/search?q=" + encodeURIComponent(query);
            }
            else{
                url = "https://www.baidu.com/s?wd=" + encodeURIComponent(query);
            }

            window.open(url);
        }
    }

    this.hexo_search();
};

// 图片缩放
ks.image(".post-content:not(.is-special) img, .page-content:not(.is-special) img");

// 请保留版权说明
if(window.console && window.console.log){
    console.log("%c Hingle %c https://paugram.com ","color: #fff; margin: 1em 0; padding: 5px 0; background: #6f9fc7;","margin: 1em 0; padding: 5px 0; background: #efefef;");
}

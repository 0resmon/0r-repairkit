const { createApp } = Vue;

const app = createApp({
    data() {
        return {
            show: {
                key: false,
                progress: false
            },
            pressingKey: false,
            type: 'numbers',
            numbers: ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
            letters: ["A", "B", "C", "D", "E", "F", "G", "H", "I"],
            currentKey: '1',
            progressBar: 0,
            keyPressSize: 0,
            needKeyPressSize: 0,
            time: 0,
            wheelSize: 11,
            bar: {},
            timeout: null,
            locales: {},
        };
    },
    methods: {
        messageHandler(event) {
            switch (event.data.action) {
                case 'progressOpen':
                    this.progressBar = 0;
                    this.show.progress = true;
                    document.getElementById('app').style.display = 'flex';
                    break;
                case 'keyOpen':
                    this.show.key = true;
                    this.type = event.data.payload.keyType;
                    this.needKeyPressSize = event.data.payload.needKeyPressSize;
                    this.keyPressSize = 0;
                    this.progressBar = 0;
                    this.time = event.data.payload.time;

                    setTimeout(() => {
                        this.bar = new ProgressBar.Circle('#test', {
                            strokeWidth: 5,
                            easing: 'linear',
                            duration: this.time * 1000,
                            color: '#EF2648',
                            trailColor: '#630F1D',
                            trailWidth: 5,
                            svgStyle: {
                                display: 'flex',
                                width: '2.1875vw'
                            }
                        });

                        this.newKey();
                    }, 100);

                    
                    break;
                case 'locales':
                    this.locales = event.data.payload;
                    break;
                case 'check_nui':
                    postNUI('nui_loaded');
                    break;
                default:
                    break;
            };
        },
        keyHandler(e) {
            if (e.which == 27) {
                this.show.key = false;
                this.show.progress = false;
                this.progressBar = 0;
                this.bar.set(0);

                document.getElementById('app').style.display = 'none';
                postNUI('closeMenu');
            } else if (e.key.toLowerCase() == this.currentKey.toLowerCase()) {
                this.pressingKey = true;
                this.keyPressSize++;
                this.progressBar = Math.floor((this.keyPressSize / this.needKeyPressSize) * 100);

                if (this.needKeyPressSize == this.keyPressSize) {
                    this.show.key = false;
                    this.show.progress = false;
                    postNUI('keySuccess');
                } else {
                    this.newKey();
                }
            } else {
                if (this.show.key) {
                    this.bar.set(0);
                    this.show.key = false;
                    this.show.progress = false;
                    postNUI('keyFailed');
                }
            }
        },
        newKey() {
            var self = this;
            this.currentKey = this.type === 'numbers' ? this.numbers[Math.floor(Math.random() * this.numbers.length)] : this.letters[Math.floor(Math.random() * this.letters.length)];
    
            this.bar.set(0);
            this.bar.animate(1, {
              duration: this.time * 1000,
            });

            clearTimeout(this.timeout);

            this.timeout = setTimeout(() => {
                if (!self.pressingKey) {
                    self.show.key = false;
                    self.show.progress = false;
                    postNUI('keyFailed');
                }
            }, this.time * 1000);
            self.pressingKey = false;
        },
    },
    computed: {
    },
    mounted() {
        window.addEventListener("message", this.messageHandler);
        window.addEventListener("keyup", this.keyHandler);
    },
    beforeDestroy() {
        window.removeEventListener("message", this.messageHandler);
        window.removeEventListener("keyup", this.keyHandler);
    },
});


app.mount("#app");

var resourceName = "0r-repairkit";

if (window.GetParentResourceName) {
    resourceName = window.GetParentResourceName();
}

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });

        return await response.json()
    } catch (error) {
        return null;
    }
};
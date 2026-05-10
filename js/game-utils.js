// 音效系统 - 使用Web Audio API生成音效
class SoundManager {
    constructor() {
        this.audioContext = null;
        this.enabled = true;
        this.init();
    }

    init() {
        try {
            this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
        } catch (e) {
            console.warn('Web Audio API not supported');
            this.enabled = false;
        }
    }

    // 播放音效
    play(type) {
        if (!this.enabled || !this.audioContext) return;

        switch (type) {
            case 'shoot':
                this.playTone(800, 0.1, 'square');
                break;
            case 'hit':
                this.playTone(400, 0.2, 'sawtooth');
                break;
            case 'explosion':
                this.playNoise(0.3);
                break;
            case 'jump':
                this.playTone(600, 0.15, 'sine');
                break;
            case 'score':
                this.playTone(1000, 0.1, 'sine');
                setTimeout(() => this.playTone(1200, 0.1, 'sine'), 100);
                break;
            case 'lose':
                this.playTone(300, 0.5, 'sine');
                break;
            case 'bounce':
                this.playTone(500, 0.05, 'sine');
                break;
        }
    }

    playTone(frequency, duration, type = 'sine') {
        const oscillator = this.audioContext.createOscillator();
        const gainNode = this.audioContext.createGain();

        oscillator.connect(gainNode);
        gainNode.connect(this.audioContext.destination);

        oscillator.frequency.value = frequency;
        oscillator.type = type;

        gainNode.gain.setValueAtTime(0.3, this.audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + duration);

        oscillator.start(this.audioContext.currentTime);
        oscillator.stop(this.audioContext.currentTime + duration);
    }

    playNoise(duration) {
        const bufferSize = this.audioContext.sampleRate * duration;
        const buffer = this.audioContext.createBuffer(1, bufferSize, this.audioContext.sampleRate);
        const data = buffer.getChannelData(0);

        for (let i = 0; i < bufferSize; i++) {
            data[i] = Math.random() * 2 - 1;
        }

        const source = this.audioContext.createBufferSource();
        const gainNode = this.audioContext.createGain();

        source.buffer = buffer;
        source.connect(gainNode);
        gainNode.connect(this.audioContext.destination);

        gainNode.gain.setValueAtTime(0.3, this.audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + duration);

        source.start(this.audioContext.currentTime);
    }

    toggle() {
        this.enabled = !this.enabled;
        return this.enabled;
    }
}

// 排行榜系统 - 使用localStorage
class Leaderboard {
    constructor(gameName) {
        this.gameName = gameName;
        this.storageKey = `leaderboard_${gameName}`;
        this.maxEntries = 10;
    }

    // 获取排行榜
    getScores() {
        const scores = localStorage.getItem(this.storageKey);
        return scores ? JSON.parse(scores) : [];
    }

    // 添加分数
    addScore(score, playerName = '玩家') {
        const scores = this.getScores();
        scores.push({
            name: playerName,
            score: score,
            date: new Date().toLocaleDateString('zh-CN')
        });
        
        scores.sort((a, b) => b.score - a.score);
        
        if (scores.length > this.maxEntries) {
            scores.length = this.maxEntries;
        }

        localStorage.setItem(this.storageKey, JSON.stringify(scores));
        return this.isHighScore(score);
    }

    // 检查是否是高分（前10名）
    isHighScore(score) {
        const scores = this.getScores();
        if (scores.length < this.maxEntries) return true;
        return score > scores[scores.length - 1].score;
    }

    // 获取最高分
    getHighScore() {
        const scores = this.getScores();
        return scores.length > 0 ? scores[0].score : 0;
    }

    // 显示排行榜
    showLeaderboard(containerId) {
        const scores = this.getScores();
        const container = document.getElementById(containerId);
        
        if (!container) return;

        let html = '<div class="leaderboard"><h3>🏆 排行榜</h3>';
        
        if (scores.length === 0) {
            html += '<p class="no-scores">暂无记录</p>';
        } else {
            html += '<ol class="score-list">';
            scores.forEach((entry, index) => {
                const medal = index === 0 ? '🥇' : index === 1 ? '🥈' : index === 2 ? '🥉' : `${index + 1}`;
                html += `<li><span class="rank">${medal}</span> <span class="name">${entry.name}</span> <span class="score">${entry.score}</span> <span class="date">${entry.date}</span></li>`;
            });
            html += '</ol>';
        }
        
        html += '</div>';
        container.innerHTML = html;
    }
}

// 导出供游戏使用
window.SoundManager = SoundManager;
window.Leaderboard = Leaderboard;

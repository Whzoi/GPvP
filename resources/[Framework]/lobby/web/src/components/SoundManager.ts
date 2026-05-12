type Sounds = {
  [key: string]: HTMLAudioElement;
};

class SoundManager {
  private static instance: SoundManager;
  private sounds: Sounds = {};

  private constructor() {}

  public static getInstance(): SoundManager {
    if (!SoundManager.instance) {
      SoundManager.instance = new SoundManager();
    }
    return SoundManager.instance;
  }

  async loadSound(key: string, path: string): Promise<void> {
    return new Promise((resolve, reject) => {
      if (!this.sounds[key]) {
        const sound = new Audio(path);
        sound.addEventListener(
          "loadeddata",
          () => {
            this.sounds[key] = sound;
            // console.log(`${key} loaded`);
            resolve();
          },
          { once: true },
        );
        sound.addEventListener(
          "error",
          (e) => {
            console.error(`Error loading sound: ${key}`);
            reject(e);
          },
          { once: true },
        );
        sound.load();
      } else {
        resolve();
      }
    });
  }

  playSound(key: string, volume: number = 1): void {
    const sound = this.sounds[key];
    if (sound) {
      const soundClone = sound.cloneNode(true) as HTMLAudioElement;
      soundClone.volume = volume;
      soundClone
        .play()
        .catch((err) => console.error("Error playing sound:", err));
    }
  }
}

const playSound = (soundType: string, volume: number = 1): void => {
  SoundManager.getInstance().playSound(soundType, volume);
};

const initializeSounds = async () => {
  const soundManager = SoundManager.getInstance();
  // await soundManager.loadSound("click", "./sounds/button_click.mp3");
  await soundManager.loadSound("hover", "./sounds/button_over.mp3");
  await soundManager.loadSound("success", "./sounds/notification_exp.mp3");
  await soundManager.loadSound("error", "./sounds/menu_error.mp3");
  await soundManager.loadSound("checkbox", "./sounds/menu_checkbox.mp3");
  await soundManager.loadSound("select","./sounds/menu_dropdown_select.mp3",);
  // await soundManager.loadSound("dropdown", "./sounds/menu_dropdown.mp3");
  await soundManager.loadSound("click2", "./sounds/button_bottombar_click.mp3");
};

initializeSounds()
  // .then(() => console.log("Sounds initialized"))
  .catch((err) => console.error("Failed to initialize sounds", err));

export { SoundManager, playSound };

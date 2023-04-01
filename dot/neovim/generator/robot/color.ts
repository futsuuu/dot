import { Hsluv } from "npm:hsluv@1.0.0";

class Color {
  color: Hsluv;

  constructor(color: string | Color | Hsluv) {
    this.color = new Hsluv();
    if (typeof color === "string") {
      this.color.hex = color;
    } else {
      this.color.hex = color.hex;
    }
    this.color.hexToHsluv();
  }

  mix(color: Color, percentage: number) {
    const new_color = new Hsluv();
    this.color.hsluvToRgb();
    new_color.rgb_r = this.color.rgb_r +
      (color.color.rgb_r - this.color.rgb_r) * percentage;
    new_color.rgb_g = this.color.rgb_g +
      (color.color.rgb_g - this.color.rgb_g) * percentage;
    new_color.rgb_b = this.color.rgb_b +
      (color.color.rgb_b - this.color.rgb_b) * percentage;
    new_color.rgbToHex();
    this.color.rgbToHsluv();
    return new Color(new_color);
  }

  get hex(): string {
    this.color.hsluvToHex();
    const hex = this.color.hex;
    this.color.hexToHsluv();
    return hex;
  }

  /** Hue */
  h(h: number) {
    this.color.hsluv_h = h;
    return this;
  }
  /** Saturation */
  s(s: number) {
    this.color.hsluv_s = s;
    return this;
  }
  /** Lightness */
  l(l: number) {
    this.color.hsluv_l = l;
    return this;
  }
}

function color(color: string | Color) {
  return new Color(color);
}

export { Color, color };

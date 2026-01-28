import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview"];

  preview() {
    const input = this.inputTarget;
    const preview = this.previewTarget;
    const file = input.files[0];

    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        preview.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }
}

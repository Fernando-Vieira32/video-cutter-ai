import { Controller } from "@hotwired/stimulus"

// Mirrors the selected file into the dropzone and only enables the submit
// button once a file is there. Drag and drop feeds the same file input, so the
// form keeps working without JavaScript.
export default class extends Controller {
  static targets = ["input", "dropzone", "placeholder", "file", "name", "size", "submit"]

  connect() {
    this.select()
  }

  select() {
    const file = this.inputTarget.files[0]

    this.unhighlight()
    this.submitTarget.disabled = !file
    this.placeholderTarget.hidden = Boolean(file)
    this.fileTarget.hidden = !file

    if (file) this.#describe(file)
  }

  highlight(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("upload__dropzone--dragging")
  }

  unhighlight() {
    this.dropzoneTarget.classList.remove("upload__dropzone--dragging")
  }

  drop(event) {
    event.preventDefault()
    this.inputTarget.files = event.dataTransfer.files
    this.select()
  }

  #describe(file) {
    this.nameTarget.textContent = file.name
    this.sizeTarget.textContent = this.#humanSize(file.size)
  }

  // Same output as Rails' number_to_human_size: base 1024, 3 significant digits.
  #humanSize(bytes) {
    const units = ["Bytes", "KB", "MB", "GB"]
    const exponent = Math.min(Math.floor(Math.log2(bytes || 1) / 10), units.length - 1)
    const value = bytes / 1024 ** exponent

    return `${Number(value.toPrecision(3))} ${units[exponent]}`
  }
}

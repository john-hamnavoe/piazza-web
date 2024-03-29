import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bridge--element"
export default class extends Controller {
  connect() {
    this.element.classList.add("invisible")
    this.render()
  }

  render() {
    let bridgeElement = new BridgeElement(this.element)
    window.webBridge.send(bridgeElement.toMessage())
  }
}
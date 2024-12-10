import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    userId: Number
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      // style: "mapbox://styles/mapbox/streets-v10"
      style: "mapbox://styles/mapbox/light-v11"
      //style: "mapbox://styles/mapbox/satellite-v9"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      let new_marker = new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
        .getElement();
      // add event listener to use Turbo Frames on click, also change color of Marker
      new_marker.addEventListener('click', (event) => {
          let map_markers = document.querySelectorAll(".mapboxgl-marker");
          map_markers.forEach((map_marker) => {
            let path = map_marker.getElementsByTagName("path")[0];
            path.setAttribute("fill", "#3FB1CE");
          })
          let svg = event.target.parentElement;
          let path = svg.getElementsByTagName("path")[0];
          path.setAttribute("fill", "#000");
          Turbo.visit(marker.id, { frame: 'aside', action: 'advance' });
        });
      // initially set color of Marker
      if (this.userIdValue == marker.id) {
        let path = new_marker.getElementsByTagName("path")[0];
        path.setAttribute("fill", "#000");
      }
    })
  }

  #fitMapToMarkers() {
    // add users longitude and latitude
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })

  }
}

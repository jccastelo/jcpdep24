object centralatomica {
  var varillasDeUranio = 10

  method varillasDeUranio() = varillasDeUranio
  method setVarillasDeUranio(cantidad) {
    varillasDeUranio = cantidad
  }

  method produccionEnergetica(ciudad) {
    return varillasDeUranio * 0.1 //en millones de kWh
  } 

  method contamina() {
    return varillasDeUranio >= 20
  }
}

object centralcarbon {
  var capacidad = 20 //en toneladas

  method capacidad() = capacidad
  method setCapacidad(cantidad) {
    capacidad = cantidad
  }

  method produccionEnergetica(ciudad) {
    return 0.5 + capacidad * ciudad.riqueza()
  }

  method contamina() = true
}

object centraleolica {
  var turbinas = 1

  method instalarTurbinas(cantidad) {
    turbinas += cantidad
  }

  method produccionEnergetica(ciudad) {
    return turbinas * 0.2 * ciudad.vientos()
  }

  method contamina() = false
}

object centralhidroelectrica {

  method produccionEnergetica(ciudad) {
    return 2 * ciudad.caudal()
  }
}
class Alquiler {
    const mesesDeContrato

    method comisionDelAgente(valorDeInmueble) {
        return mesesDeContrato * valorDeInmueble / 50000
    }
}


object venta {
    var porcentajeDeInmueble = 1.5

    method porcentajeDeInmueble(nuevoValor) {
        porcentajeDeInmueble = nuevoValor
    }

    method comisionDelAgente(valorDeInmueble) {
        return valorDeInmueble * (porcentajeDeInmueble / 100)
    }
}

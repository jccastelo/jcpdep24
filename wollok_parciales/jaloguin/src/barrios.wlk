import src.personas.*

class Barrio {
    const niniosDelBarrio = []

    method topMasCaramelos(tamanioDelTop) {
        return niniosDelBarrio.sortBy({ninio1, ninio2 => ninio1.caramelos() > ninio2.caramelos()}).take(tamanioDelTop)
    }

    method top3MasCaramelos() {
        return self.topMasCaramelos(3)
    }

    method elementosNiniosConMasCaramelos() {
        return self.topMasCaramelos(10).flatMap({ninio => ninio.elementos()}).asSet()
    }
}
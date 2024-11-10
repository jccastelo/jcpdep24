import src.guerreros.*
import src.trajes.*

object torneo {
    const peleadores = #{}

    method powerIsBest() {
        return peleadores.sortedBy({peleador1, peleador2 => peleador1.potencialOfensivo() > peleador2.potencialOfensivo()}).take(16)
    }

    method funny() {
        return peleadores.sortedBy({peleador1, peleador2 => peleador1.elementosDelTraje() > peleador2.elementosDelTraje()}).take(16)
    }

    method surprise() {
        return peleadores.randomized().take(16)
    }
}
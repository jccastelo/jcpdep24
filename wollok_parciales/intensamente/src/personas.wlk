import src.emociones.*
import src.recuerdos.Recuerdo

class Persona {
    var felicidad
    var emocionDominante
    const recuerdosDelDia = []
    const pensamientosCentrales = #{}
    const memoriaLargoPlazo = []

    method felicidad() = felicidad
    method emocionDominante() = emocionDominante
    method emocionDominante(emocion) {
        emocionDominante = emocion
    }

    method pensamientosCentrales() = pensamientosCentrales
    method recuerdosDelDia() = recuerdosDelDia

    method vivirEvento(descripcionEvento) {
        const recuerdo = new Recuerdo(descripcion= descripcionEvento, emocionDelRecuerdo = emocionDominante)
        recuerdosDelDia.add(recuerdo)
    }

    method asentarRecuerdo(recuerdo) {
        recuerdo.emocionDelRecuerdo().asentarRecuerdo(self, recuerdo)
    }

    method agregarPensamientoCentral(recuerdo) {
        pensamientosCentrales.add(recuerdo)
    }

    method tieneMasFelicidadQue(cantidad) {
        return felicidad > cantidad
    }

    method disminuirPorcentajeAlegria(porcentaje) {
        felicidad -= (felicidad * porcentaje/100)
    }

    method recuerdosRecientes() {
        return recuerdosDelDia.reverse().take(5)
    }

    method pensamientosCentralesDificiles() {
        return pensamientosCentrales.filter({recuerdo => recuerdo.esDificilDeExplicar()})
    }


    //p2

    method niegaRecuerdo(recuerdo) {
        return emocionDominante.niega(recuerdo.emocionDominante())
    }

    method asentarRecuerdos() {
        recuerdosDelDia.forEach({recuerdo => self.asentarRecuerdo(recuerdo)})
    }

    method asentarRecuerdosSelectivos(palabra) {
        const recuerdosFiltrados = recuerdosDelDia.filter({recuerdo => recuerdo.descrpcion().contains(palabra)})
        recuerdosFiltrados.forEach({recuerdo => self.asentarRecuerdo(recuerdo)})
    }

    method profundizar() {
        const recuerdosLargoPlazo = recuerdosDelDia.filter({recuerdo => !self.esCentral(recuerdo) && !emocionDominante.niega(recuerdo.emocionDominante())})
        memoriaLargoPlazo.union(recuerdosLargoPlazo)
    }

    method esCentral(recuerdo) {
        return pensamientosCentrales.contains(recuerdo)
    }

    method controlHormonal() {
        if (self.huboDescontrolHormonal()) {
            self.disminuirPorcentajeAlegria(15)
            pensamientosCentrales.drop(3)
        }
    }

    method huboDescontrolHormonal() {
        const emocionBuscada = recuerdosDelDia.anyOne({recuerdo => recuerdo.emocionDominante()})
        return (pensamientosCentrales.intersection(memoriaLargoPlazo)).size() > 1 || recuerdosDelDia.all({recuerdo => recuerdo.emocionDominante() == emocionBuscada})
    }

    method restauracionCognitiva() {
        felicidad = 1000.min(felicidad + 100)
    }

    method liberarRecuerdosDelDia() {
        recuerdosDelDia.clear()
    }

    method dormir() {
        self.asentarRecuerdos()
        self.profundizar()
        self.controlHormonal()
        self.restauracionCognitiva()
        self.liberarRecuerdosDelDia()
    }
}

const riley = new Persona(felicidad=1000, emocionDominante= alegria)





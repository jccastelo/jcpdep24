import src.emociones.*

class Recuerdo {
    const descripcion
    const emocionDelRecuerdo

    method descripcion() = descripcion
    method emocionDelRecuerdo() = emocionDelRecuerdo

    method esDificilDeExplicar() {
        return descripcion.size() > 10
    }
}
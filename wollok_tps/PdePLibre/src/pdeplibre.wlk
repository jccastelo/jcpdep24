import src.usuarios.Usuario
import src.producto.*

object pdepLibre {
    const productos = []
    const usuarios = #{}

    method penalizarMorosos() {
        self.usuariosMorosos().forEach({ usuario => usuario.penalizar() })
    }

    method usuariosMorosos() {
        return usuarios.filter( {usuario => usuario.esMoroso() })
    }

    method eliminarCuponesUsados() {
        usuarios.forEach({ usuario => usuario.eliminarCuponesUsados() })
    }

    method nombresDeProductosDeOFerta() {
        return productos.map({ unProducto => unProducto.nombreEnOferta() })
    }

    method actualizarNivelDeUsuarios() {
        usuarios.forEach({ usuario => usuario.actualizarNivel()})
    }
}
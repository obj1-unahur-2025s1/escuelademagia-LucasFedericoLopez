class Criatura {
  var salud
  method aumentarSalud(unValor) {
    salud += unValor
  }
  method disminuirSalud(unValor) {
    salud = 0.max(salud - unValor)
  }
  method puedeHacerUnHechizo(unHechizo) = false
  method recibirHechizo(unHechizo) {
    self.disminuirSalud(unHechizo.impactoSobre(self))
  }
}
class CriaturaInmune inherits Criatura {
    override method recibirHechizo(unHechizo) {}
}

class Estudiante inherits Criatura{
  const hechizos = []
  const materias = []
  var casa
  var habilidad
  const sangre
  method aumentarHabilidad(unValor) {
    habilidad += unValor
  }
  method disminuirHabilidad(unValor) {
    habilidad = 0.max(habilidad - unValor)
  }
  method cambiarDeCasa(unaCasa) {
    casa = unaCasa
  }
  method anotarseA(unaMateria) {
    materias.add(unaMateria)
  }
  method bajarseDe(unaMateria) {
    materias.remove(unaMateria)
  }
  method aprender(unHechizo) {
    hechizos.add(unHechizo)
  }
  method aprendioHechizo(unHechizo) = hechizos.contains(unHechizo)
  override method puedeHacerUnHechizo(unHechizo) = self.aprendioHechizo(unHechizo) and unHechizo.puedeRealizarlo(self)
  method lanzar(unHechizo,destinatario) {
    if(self.puedeHacerUnHechizo(unHechizo)) {
    unHechizo.lanzarHechizo(self,destinatario)
    }
    else {
      self.error("No puede realizar ese hechizo")
    }
  }
  method esPeligroso() =
    if(salud == null) {
      false
    }
    else {
      casa.condicionExtra(self)
    }
}

class Casa {
  method condicionExtra(unEstudiante)
}

class Gryffindor inherits Casa {
  override method condicionExtra(unEstudiante) = false
}
class Slytherin inherits Casa {
  override method condicionExtra(unEstudiante) = true
}
class Ravenclaw inherits Casa {
  override method condicionExtra(unEstudiante) = unEstudiante.habilidad() > 10
}
class Hufflepuff inherits Casa {
  override method condicionExtra(unEstudiante) = unEstudiante.sangre()
}

class Materia {
  const estudiantes = []
  const profesor
  var hechizoActual
  method aprenderHechizo(unHechizo) {
    estudiantes.forEach({e=>e.aumentarHabilidad(1)})
    estudiantes.aprender(hechizoActual)
  }
  method cambiarHechizo(unHechizo) {
    hechizoActual = unHechizo
  }
  method practicar(unaCriatura) {
    estudiantes.forEach({e=>e.lanzar(hechizoActual, unaCriatura)})
  }
}

class Hechizo {
    const nivelDificultad
    method puedeRealizarlo(unEstudiante) = unEstudiante.habilidad() > nivelDificultad
    method lanzarHechizo(emisor, destinatario) {
        destinatario.recibirHechizo(self)
    }
    method impactoSobre(destinatario) = nivelDificultad + 10
}


class HechizoComun inherits Hechizo {
  
}
class HechizoImperdonable inherits Hechizo {
    const sacrificaVida
    override method lanzarHechizo(emisor, destinatario) {
        super(emisor, destinatario)
        emisor.disminuirSalud(sacrificaVida)
    }
    override method impactoSobre(destinatario) = super(destinatario) * 2
}


class HechizosNoPeligrosos inherits Hechizo {
    override method puedeRealizarlo(unEstudiante) = !unEstudiante.esPeligroso()
    override method lanzarHechizo(emisor, destinatario) {
        super(emisor, destinatario)
        emisor.disminuirHabilidad(1)
    }
}

class HechizoCambioDeCasa inherits Hechizo {
    const casaDestino

    override method puedeRealizarlo(unEstudiante) {
        return self.permiteSegunSangre(unEstudiante)
    }

    method permiteSegunSangre(unEstudiante) {
        return unEstudiante.sangre()
    }
    
    override method lanzarHechizo(emisor, destinatario) {
        super(emisor, destinatario)
        emisor.cambiarDeCasa(casaDestino)
    }
}

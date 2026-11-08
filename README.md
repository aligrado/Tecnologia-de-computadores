# 💣 Bombinaria – Juego de desactivación de bombas en FPGA

## 1. Descripción del proyecto

**Bombinaria** es un videojuego desarrollado en lenguaje **VHDL** e implementado sobre una FPGA **Basys 3 de Xilinx**, como proyecto final de la asignatura Tecnología de Computadores.

El juego está inspirado en la mecánica clásica de desactivación de bombas: el jugador debe averiguar un número generado por el sistema y conseguir introducirlo correctamente antes de que termine una cuenta atrás. Para ello, dispone de un tiempo limitado y de dos botones que permiten iniciar la partida y confirmar la desactivación.

El objetivo principal es introducir el número correcto de 8 bits antes de que el temporizador llegue a cero. Si el número introducido coincide con el generado por el sistema, la bomba queda desactivada. En caso contrario, se produce una explosión.

La implementación utiliza los recursos físicos de la placa FPGA para interactuar con el jugador:

- **8 interruptores (switches):** permiten introducir el número de 8 bits.
- **Botón de inicio:** comienza una nueva partida.
- **Botón de desactivación:** permite detener la cuenta atrás y comprobar el número introducido.
- **16 LEDs:** representan los diferentes estados del juego mediante secuencias luminosas.
- **Display de 7 segmentos:** muestra el número generado y la cuenta atrás.

El proyecto está desarrollado mediante módulos VHDL independientes, siguiendo una arquitectura basada en una unidad de control (*Controller*) y una unidad de procesamiento (*Datapath*).

---

## 2. Funcionamiento del juego

La partida se desarrolla a través de diferentes fases:

### 2.1. Estado inicial

Al encender la placa o activar el reset, el sistema permanece en estado de espera.

Los LEDs están apagados y los contadores se encuentran reiniciados. El juego espera a que el jugador pulse el botón de inicio.

### 2.2. Generación del número

Cuando se pulsa el botón de inicio, comienza una fase de generación de un número de 8 bits.

Para generar este número se utiliza un contador de 8 bits que incrementa continuamente su valor. El jugador dispone de aproximadamente 5 segundos durante esta fase.

Una vez transcurrido ese tiempo, el contador deja de incrementarse y su valor queda almacenado como número objetivo de la partida.

Durante esta fase, los LEDs muestran una animación que representa que el sistema está esperando la generación del número.

### 2.3. Cuenta atrás

Una vez generado el número, comienza la cuenta atrás.

El temporizador parte de un valor de 15 y va decrementándose periódicamente hasta llegar a cero.

El jugador debe introducir en los ocho interruptores de la placa el número que cree que ha sido generado.

El valor introducido se interpreta como un número binario de 8 bits.

### 2.4. Intento de desactivación

El jugador puede pulsar el botón de desactivación para detener la cuenta atrás y comprobar su respuesta.

En ese momento, el sistema compara:

- El número generado internamente (`numRand`).
- El número introducido mediante los interruptores (`numero`).

Se pueden producir dos situaciones:

**Desactivación correcta:**

Si ambos números coinciden, el sistema entra en el estado de bomba desactivada.

Los 16 LEDs muestran una animación luminosa que representa que la bomba ha sido desactivada correctamente.

**Desactivación incorrecta:**

Si los números no coinciden, el sistema entra en el estado de explosión.

Los LEDs muestran una secuencia de encendido y apagado que representa la explosión de la bomba.

Si la cuenta atrás llega a cero, el sistema también finaliza la fase de desactivación y comprueba el número introducido.

### 2.5. Final de la partida

Tanto en el caso de desactivación correcta como en el de explosión, se mantiene la animación correspondiente durante aproximadamente 5 segundos.

Una vez finalizado ese intervalo, el sistema vuelve al estado inicial y permite comenzar una nueva partida.

---

## 3. Componentes hardware utilizados

El proyecto está diseñado para ejecutarse sobre una placa **Basys 3**, que incorpora una FPGA Xilinx Artix-7.

Los recursos físicos utilizados son los siguientes:

| Componente | Función |
|---|---|
| FPGA Artix-7 | Ejecuta el diseño digital implementado en VHDL. |
| Reloj de 100 MHz | Proporciona la señal de sincronización principal. |
| 8 switches | Introducen el número de 8 bits. |
| Botón de inicio | Inicia una partida. |
| Botón de desactivación | Confirma el intento de desactivación. |
| Botón de reset | Reinicia el sistema. |
| 16 LEDs | Representan visualmente los estados del juego. |
| Display de 7 segmentos | Muestra el número generado y la cuenta atrás. |

### 3.1. Interruptores

Los ocho interruptores representan un número binario de 8 bits, con un rango comprendido entre 0 y 255.

La entrada se conecta al puerto `numero(7 downto 0)` del módulo principal.

### 3.2. LEDs

Los 16 LEDs se utilizan para representar diferentes animaciones:

- Espera y generación del número.
- Bomba desactivada.
- Explosión.

Cada animación está implementada en un módulo VHDL independiente.

### 3.3. Display de 7 segmentos

El display de cuatro dígitos se utiliza para mostrar información del juego.

La distribución implementada es:

| Dígito | Información |
|---|---|
| Dígito 0 | 4 bits inferiores del número generado. |
| Dígito 1 | 4 bits superiores del número generado. |
| Dígito 2 | Cero. |
| Dígito 3 | Valor de la cuenta atrás. |

Los dos primeros dígitos permiten visualizar el número generado en hexadecimal, mientras que el último muestra el tiempo restante.

---

## 4. Arquitectura del sistema

El diseño está organizado de forma modular, separando el control del funcionamiento de los contadores y las salidas.

La arquitectura principal se divide en tres bloques:

1. **Divisor de frecuencia:** genera las señales de reloj necesarias para los diferentes procesos.
2. **Controller:** implementa la máquina de estados y determina las operaciones que debe realizar el sistema.
3. **Datapath:** contiene los contadores, registros y circuitos encargados de generar las secuencias de LEDs.

La conexión entre estos bloques se realiza mediante señales de control y datos.

---

## 5. Máquina de estados (Controller)

El módulo `controller.vhd` implementa una máquina de estados finitos (FSM) encargada de controlar el desarrollo de la partida.

Se utilizan seis estados:

| Estado | Nombre | Descripción |
|---|---|---|
| S0 | Reposo | Espera a que se pulse el botón de inicio. |
| S1 | Generación | Genera el número durante 5 segundos. |
| S2 | Cuenta atrás | Decrementa el temporizador y espera la desactivación. |
| S3 | Comparación | Comprueba si el número introducido coincide con el generado. |
| S4 | Desactivada | Muestra la animación de desactivación correcta. |
| S5 | Explosión | Muestra la animación de explosión. |

### Transiciones entre estados

- **S0 → S1:** se pulsa el botón de inicio.
- **S1 → S2:** finaliza el periodo de generación del número.
- **S2 → S3:** se pulsa el botón de desactivación o la cuenta atrás llega a cero.
- **S3 → S4:** el número introducido coincide con el número generado.
- **S3 → S5:** los números son diferentes.
- **S4 → S0:** finaliza la animación de desactivación.
- **S5 → S0:** finaliza la animación de explosión.

El controlador genera un vector de siete bits (`ctrl`) que contiene las señales necesarias para controlar el Datapath:

| Bits | Señal | Función |
|---|---|---|
| `ctrl(0)` | `rst_conts` | Reset de los contadores principales y secuencias de LEDs. |
| `ctrl(1)` | `rst_cont5seg` | Reset del contador utilizado para los intervalos de 5 segundos. |
| `ctrl(2)` | `enable_numRand` | Habilita el contador de generación del número. |
| `ctrl(3)` | `enable_cont5seg` | Habilita el contador de 5 segundos. |
| `ctrl(4)` | `enable_cuentaAtras` | Habilita la cuenta atrás. |
| `ctrl(6 downto 5)` | `mux_leds` | Selecciona la secuencia de LEDs que se muestra. |

---

## 6. Módulos VHDL

Los archivos fuente se encuentran en:

`BombinariaTC.srcs/sources_1/new/`

A continuación se describen los módulos que forman el proyecto.

### 6.1. Módulos principales

| Archivo | Descripción |
|---|---|
| `sintesis_bombinaria.vhd` | Módulo de nivel superior. Conecta los botones, el controlador del juego y las salidas físicas de la FPGA. |
| `bombinaria.vhd` | Integra el divisor de frecuencia, el Controller y el Datapath. |
| `controller.vhd` | Implementa la máquina de estados y genera las señales de control. |
| `datapath.vhd` | Integra los contadores y los generadores de secuencias luminosas. |

### 6.2. Módulos de contadores

| Archivo | Descripción |
|---|---|
| `divisor.vhd` | Divide el reloj principal de 100 MHz para obtener señales de diferentes frecuencias. |
| `contador_8bits.vhd` | Genera el número de 8 bits mediante un contador ascendente. |
| `contadorCuentaAtras.vhd` | Implementa el temporizador descendente que comienza en 15. |
| `contadorMod10.vhd` | Implementa un contador decimal de 0 a 9, utilizado para medir los intervalos de 5 segundos. |
| `contadorMod16.vhd` | Implementa un contador de 4 bits con módulo 16. |

### 6.3. Módulos de visualización

| Archivo | Descripción |
|---|---|
| `displays.vhd` | Controla el refresco y la selección de los cuatro dígitos del display. |
| `conv_7seg.vhd` | Convierte un número de 4 bits en el patrón correspondiente del display de 7 segmentos. |

### 6.4. Módulos de LEDs

| Archivo | Descripción |
|---|---|
| `esperando_numero.vhd` | Implementa un registro de desplazamiento que genera la animación de espera. |
| `defusada_leds.vhd` | Genera la secuencia luminosa de bomba desactivada. |
| `explosion_leds.vhd` | Genera la secuencia de encendido y apagado de todos los LEDs para representar una explosión. |
| `defusada_explosion_leds.vhd` | Implementa una lógica alternativa de generación de secuencias para los estados de desactivación y explosión. |

### 6.5. Módulos auxiliares

| Archivo | Descripción |
|---|---|
| `debouncer.vhd` | Elimina los rebotes mecánicos de los botones para generar señales de pulsación estables. |

---

## 7. Tratamiento de los botones: Debouncer

Los botones físicos de una FPGA pueden producir múltiples transiciones eléctricas cuando se pulsan o se sueltan, debido a los rebotes mecánicos.

Para evitar que una única pulsación sea interpretada como varias, se utiliza el módulo `debouncer.vhd`.

Este módulo realiza tres operaciones:

1. Sincroniza la entrada del botón con el reloj del sistema.
2. Espera un intervalo de aproximadamente 50 ms para comprobar que la señal se ha estabilizado.
3. Genera señales que identifican los flancos de subida y bajada de la pulsación.

En el proyecto se instancian dos módulos Debouncer independientes:

- Uno para el botón de inicio.
- Otro para el botón de desactivación.

De esta manera, el controlador recibe señales de pulsación más fiables.

---

## 8. División de frecuencia

El reloj principal de la Basys 3 funciona a 100 MHz, una frecuencia demasiado elevada para representar directamente los intervalos temporales del juego.

Por ello, el módulo `divisor.vhd` genera cuatro señales auxiliares mediante contadores internos.

Estas señales se utilizan para controlar:

- El contador de generación del número.
- El refresco del display.
- Las animaciones de LEDs.
- La cuenta atrás.

La división de frecuencia permite que los cambios de estado y las animaciones sean visibles para el jugador.

---

## 9. Configuración de la FPGA

El proyecto incluye el archivo de restricciones:

`BombinariaTC.srcs/constrs_1/new/Basys3_Master.xdc`

Este archivo establece la correspondencia entre las señales del diseño VHDL y los pines físicos de la placa Basys 3.

Entre las asignaciones configuradas se encuentran:

- Reloj principal: `clk`.
- Interruptores: `numero(7 downto 0)`.
- Botón de reset: `rst`.
- Botón de inicio: `boton_inicio`.
- Botón de desactivación: `boton_defusar`.
- LEDs: `leds(15 downto 0)`.
- Segmentos del display: `display(6 downto 0)`.
- Selección de dígitos: `s_display(3 downto 0)`.

---

## 10. Instalación y ejecución

Para abrir y ejecutar el proyecto se necesita:

- **Xilinx Vivado**, para sintetizar, implementar y programar el diseño.
- Una placa FPGA **Basys 3**.
- Un cable USB para conectar la placa al ordenador.

### Pasos para ejecutar el proyecto

1. Descargar o clonar el repositorio.
2. Abrir Xilinx Vivado.
3. Crear un proyecto nuevo seleccionando la FPGA correspondiente a la placa Basys 3.
4. Añadir los archivos VHDL de la carpeta `sources_1/new/`.
5. Añadir el archivo de restricciones `Basys3_Master.xdc`.
6. Seleccionar `sintesis_bombinaria` como módulo superior (*Top Module*).
7. Ejecutar la síntesis (*Run Synthesis*).
8. Ejecutar la implementación (*Run Implementation*).
9. Generar el archivo de programación (*Generate Bitstream*).
10. Conectar la placa Basys 3 y programar la FPGA mediante *Hardware Manager*.

Una vez programada la placa, el juego estará listo para ejecutarse.

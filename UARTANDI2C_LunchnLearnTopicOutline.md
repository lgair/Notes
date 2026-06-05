# UART & I2C: Communication Protocols in Practice

## Presentation Goal

A practical, experience-driven overview of two of the most common embedded communication protocols: UART and I2C.

Target audience:

* Embedded software developers
* Firmware developers
* Junior to intermediate engineers

Presentation length:

* ~25 minutes
* Roughly 1 minute per slide
* Lightweight technical depth
* Focused on practical engineering lessons and debugging intuition

---

# Slide 1 — Title Slide

## UART & I2C: Communication Protocols in Practice

Subtitle:
Practical lessons, tradeoffs, and debugging experiences from embedded development.

Talking points:

* Quick intro
* Mention calibration, embedded communication, and device integration work
* Set expectation:

  * not a deep electrical engineering lecture
  * focused on practical embedded software concerns

---

# Slide 2 — Why Communication Protocols Matter

Main idea:
Embedded systems are collections of components constantly exchanging information.

Examples:

* Sensors
* Displays
* Motor controllers
* Microcontrollers
* Calibration equipment

Key point:
A large percentage of embedded bugs eventually become communication bugs.

Transition:
Today we’ll look at two extremely common protocols:

* UART
* I2C

---

# Slide 3 — What is UART?

Definition:
Universal Asynchronous Receiver/Transmitter

Core concepts:

* Point-to-point communication
* TX and RX lines
* No shared clock
* Baud rate must match

Good visual:
Simple diagram showing:
MCU TX -> Device RX
MCU RX <- Device TX

Key takeaway:
UART is simple, direct, and easy to debug.

---

# Slide 4 — UART Packet Structure

Show a simple UART frame:

* Start bit
* Data bits
* Optional parity
* Stop bit

Focus on:

* asynchronous timing
* sender and receiver agreeing on baud rate

Practical note:
Even small baud mismatches can create strange bugs.

Keep visuals simple.

---

# Slide 5 — Where UART Works Well

Examples:

* Debug consoles
* GPS modules
* Bluetooth modules
* Logging systems
* Device-to-device communication

Advantages:

* Easy to implement
* Minimal hardware complexity
* Human-readable protocols possible
* Great tooling support

Mention:
Serial terminals are incredibly useful during development.

---

# Slide 6 — Common UART Problems

Common issues:

* Baud mismatch
* Packet desynchronization
* Partial reads
* Buffer overflows
* Noise/corrupted bytes

Practical debugging tools:

* Serial console
* Hex dumps
* Logic analyzer
* Oscilloscope

Key point:
UART problems are often visible and diagnosable.

---

# Slide 7 — What is I2C?

Definition:
Inter-Integrated Circuit

Core concepts:

* Shared bus
* SDA + SCL
* Address-based communication
* Master/slave architecture

Good visual:
One MCU connected to multiple devices on same bus.

Key takeaway:
I2C reduces wiring complexity and supports many peripherals.

---

# Slide 8 — How I2C Communication Works

Briefly cover:

* Start condition
* Address
* Read/write bit
* ACK/NACK
* Stop condition

Do not go too deep.

Main focus:
I2C is more structured and coordinated than UART.

Mention:
Clock line simplifies synchronization compared to UART.

---

# Slide 9 — Where I2C Works Well

Examples:

* Sensors
* EEPROMs
* Power management ICs
* Small peripheral devices
* Display controllers

Advantages:

* Multiple devices on two wires
* Efficient PCB routing
* Widely supported by embedded hardware

Key point:
I2C is extremely common for on-board peripheral communication.

---

# Slide 10 — Common I2C Problems

Common issues:

* Missing pull-up resistors
* Bus lockups
* Clock stretching issues
* Address conflicts
* Devices hanging the bus

Practical note:
I2C bugs can be frustrating because the entire bus can fail.

Debugging tools:

* Logic analyzer
* Bus decoder tools
* Oscilloscope

---

# Slide 11 — UART vs I2C: Quick Comparison

Suggested table:

| Topic        | UART            | I2C                     |
| ------------ | --------------- | ----------------------- |
| Wiring       | Simple          | Efficient               |
| Device Count | Point-to-point  | Multi-device            |
| Complexity   | Low             | Medium                  |
| Debugging    | Easier          | Harder                  |
| Typical Use  | Logging/modules | Sensors/peripherals     |
| Reliability  | Often robust    | Sensitive to bus issues |

Key point:
Neither protocol is universally “better.”

---

# Slide 12 — Choosing the Right Protocol

Discussion points:

Choose UART when:

* Simplicity matters
* You need debugging visibility
* Point-to-point is acceptable
* Human-readable protocols help

Choose I2C when:

* Many peripherals are needed
* PCB space is limited
* Devices already support I2C
* Lower pin count matters

Key takeaway:
Protocol choice depends on system constraints.

---

# Slide 13 — Debugging Lessons Learned

Share 2–3 practical lessons.

Possible examples:

* Always validate physical connections first
* Communication bugs are often timing bugs
* Logging is invaluable
* Logic analyzers save enormous time
* Reproduce issues consistently before changing code

This slide should feel conversational and experience-driven.

---

# Slide 14 — Tools That Help

Show or mention:

* Logic analyzer
* Serial terminal
* Oscilloscope
* Protocol decoders
* Logging infrastructure

Potential angle:
Good tooling dramatically reduces debugging time.

Could mention Saleae if your team uses it.

---

# Slide 15 — Real-World Engineering Reality

Key idea:
Communication protocols usually look simple in documentation.

Real systems introduce:

* Noise
* Timing problems
* Bad cables
* Firmware bugs
* Power sequencing issues
* Hardware assumptions

Main takeaway:
Practical debugging experience matters as much as protocol knowledge.

---

# Slide 16 — Key Takeaways

Summarize:

* UART is simple and highly debuggable
* I2C is efficient and flexible
* Both have common failure modes
* Debugging methodology matters
* Tooling is essential

Keep this concise.

---

# Slide 17 — Questions

Simple ending slide.

Potential prompt:
“What communication bugs have wasted the most of your time?”

This often encourages discussion.

---

# Presentation Notes

## Recommended Style

* Keep slides visually clean
* Avoid large blocks of text
* Use diagrams whenever possible
* Keep technical detail lightweight
* Speak from practical experience

## Suggested Visuals

* UART frame diagram
* I2C shared bus diagram
* Logic analyzer screenshots
* Example packet structures
* Comparison tables

## Delivery Advice

* Keep the pace conversational
* Avoid reading slides directly
* Use real debugging stories where possible
* Prioritize clarity over completeness

## Optional Additions

If time allows:

* Brief SPI mention as “another common protocol”
* Live serial terminal demo
* Logic analyzer screenshots from real hardware
* Funny debugging story


# Harnesses por agente

Cada agente que participe en una corrida necesita un harness propio. El harness evita que un rol sea solo un prompt bonito: declara qué recibe, qué puede usar, qué entrega, cómo se verifica, cuándo se detiene y qué hace al fallar.

Copia `PLANTILLA-HARNESS-AGENTE.md` una vez por rol en `harnesses/<rol>.md`. El líder también necesita harness. En un Nest, por defecto solo el líder consolida memoria y escribe la salida. En un Swarm, el contrato debe nombrar un único rol que consolida memoria duradera al final de la corrida.

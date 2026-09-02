CREATE TABLE Bestilling (
    bestilling_id   SERIAL       PRIMARY KEY,
    bestilling_dato DATE         NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Pizza (
    pizza_navn      VARCHAR(50)  PRIMARY KEY
);

CREATE TABLE Storrelse (
    storrelse_navn  VARCHAR(50)  PRIMARY KEY
);

CREATE TABLE Bund (
    bund_navn       VARCHAR(50)  PRIMARY KEY
);


CREATE TABLE Topping (
    topping_navn       VARCHAR(50)  PRIMARY KEY,
    topping_er_vegetar BOOLEAN      NOT NULL,
    topping_er_vegan   BOOLEAN      NOT NULL,
    topping_pris       NUMERIC(6,2) NOT NULL CHECK (topping_pris >= 0),
    topping_tid        INTEGER      NOT NULL CHECK (topping_tid >= 0)
);


-- En topping kan have flere allergener (1NF: udtrukket multivaerdi).
-- Valg: 'allergen' er ren tekst (PK-del), ingen selvstaendig Allergen-tabel.
-- Alternativ: lav en Allergen-tabel og gor 'allergen' til FK.
CREATE TABLE ToppingAllergen (
    topping_navn VARCHAR(50) NOT NULL,
    allergen     VARCHAR(50) NOT NULL,
    PRIMARY KEY (topping_navn, allergen),
    FOREIGN KEY (topping_navn) REFERENCES Topping(topping_navn)
);

-- Junction-tabel: hvilke (signatur-)toppings hoerer til hvilken pizza (M:N).
CREATE TABLE PizzaOpskrift (
    pizza_navn   VARCHAR(50) NOT NULL,
    topping_navn VARCHAR(50) NOT NULL,
    PRIMARY KEY (pizza_navn, topping_navn),
    FOREIGN KEY (pizza_navn)   REFERENCES Pizza(pizza_navn),
    FOREIGN KEY (topping_navn) REFERENCES Topping(topping_navn)
);

-- Pris pr. kombination. PK (pizza, storrelse, bund) er samtidig UNIQUE-kravet.
CREATE TABLE PizzaPris (
    pizza_navn     VARCHAR(50)  NOT NULL,
    storrelse_navn VARCHAR(50)  NOT NULL,
    bund_navn      VARCHAR(50)  NOT NULL,
    standardpris   NUMERIC(6,2) NOT NULL CHECK (standardpris >= 0),
    PRIMARY KEY (pizza_navn, storrelse_navn, bund_navn),
    FOREIGN KEY (pizza_navn)     REFERENCES Pizza(pizza_navn),
    FOREIGN KEY (storrelse_navn) REFERENCES Storrelse(storrelse_navn),
    FOREIGN KEY (bund_navn)      REFERENCES Bund(bund_navn)
);


-- Standard-produktionstid afhaenger af storrelse + bund.
CREATE TABLE Produktionstid (
    storrelse_navn          VARCHAR(50) NOT NULL,
    bund_navn               VARCHAR(50) NOT NULL,
    standard_produktionstid INTEGER     NOT NULL CHECK (standard_produktionstid > 0),
    PRIMARY KEY (storrelse_navn, bund_navn),
    FOREIGN KEY (storrelse_navn) REFERENCES Storrelse(storrelse_navn),
    FOREIGN KEY (bund_navn)      REFERENCES Bund(bund_navn)
);

-- En linje i en bestilling: en pizza-storrelse-bund-kombination + antal.
CREATE TABLE Bestillingslinje (
    bestilling_id  INTEGER     NOT NULL,
    pizza_navn     VARCHAR(50) NOT NULL,
    storrelse_navn VARCHAR(50) NOT NULL,
    bund_navn      VARCHAR(50) NOT NULL,
    antal          INTEGER     NOT NULL CHECK (antal > 0),
    PRIMARY KEY (bestilling_id, pizza_navn, storrelse_navn, bund_navn),
    FOREIGN KEY (bestilling_id)  REFERENCES Bestilling(bestilling_id),
    FOREIGN KEY (pizza_navn)     REFERENCES Pizza(pizza_navn),
    FOREIGN KEY (storrelse_navn) REFERENCES Storrelse(storrelse_navn),
    FOREIGN KEY (bund_navn)      REFERENCES Bund(bund_navn)
);


-- Ekstra toppings tilvalgt paa en konkret bestillingslinje.
CREATE TABLE BestillingEkstra (
    bestilling_id  INTEGER     NOT NULL,
    pizza_navn     VARCHAR(50) NOT NULL,
    storrelse_navn VARCHAR(50) NOT NULL,
    bund_navn      VARCHAR(50) NOT NULL,
    topping_navn   VARCHAR(50) NOT NULL,
    PRIMARY KEY (bestilling_id, pizza_navn, storrelse_navn, bund_navn, topping_navn),
    FOREIGN KEY (bestilling_id, pizza_navn, storrelse_navn, bund_navn)
        REFERENCES Bestillingslinje(bestilling_id, pizza_navn, storrelse_navn, bund_navn),
    FOREIGN KEY (topping_navn) REFERENCES Topping(topping_navn)
);

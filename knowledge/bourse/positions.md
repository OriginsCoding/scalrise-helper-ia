---
title: Positions boursières
module: bourse
route: /stocks/portfolio
page_type: fonctionnalité
version: 1.0
---

# Positions boursières

Tags : position boursière, ajouter une position, importer des positions, import CSV, fichier CSV, actions détenues, quantité, prix de revient, prix d'achat, date d'achat, portefeuille, PEA, CTO, broker, courtier, import manuel, intelligence artificielle, ChatGPT

## Présentation

Une position représente une action ou un titre détenu dans un portefeuille boursier.

Les positions sont accessibles depuis :

**Bourse → Portfolio**

Chaque position est rattachée au portefeuille affiché.

## Ajouter une position

Le bouton **Ajouter une position** permet d’enregistrer une nouvelle position dans le portefeuille.

L’ajout peut être réalisé manuellement en renseignant les informations demandées dans le formulaire.

La capture fournie ne montre pas le détail complet du formulaire d’ajout manuel.

Scalia ne doit donc pas inventer les champs qui ne sont pas documentés.

## Import manuel uniquement

Scalrise ne dispose pas d’une connexion directe avec les banques, les courtiers ou les brokers.

Il n’existe pas de synchronisation automatique avec :

- Boursobank ;
- Trade Republic ;
- Degiro ;
- Fortuneo ;
- ou un autre établissement financier.

Les positions doivent être ajoutées :

- manuellement (une position à la fois) ;
- ou à l’aide d’un fichier CSV et d'un prompt IA.

## Import des positions via CSV

Une section **Importer des positions via CSV** permet d’ajouter plusieurs positions à partir d’un fichier CSV.

Le processus affiché est le suivant :

1. Faire une capture d’écran des positions depuis son courtier.
2. Ouvrir un assistant d’intelligence artificielle capable d’analyser une image.
3. Utiliser le prompt fourni par Scalrise.
4. Générer un fichier CSV dans le format attendu.
5. Télécharger le fichier CSV généré.
6. Importer le fichier dans Scalrise avec le bouton **Choisir un fichier CSV**.

## Aide par intelligence artificielle

Scalrise fournit un prompt prêt à copier pour demander à une intelligence artificielle de transformer une capture d’écran du broker en fichier CSV.

Le format attendu est :

```text
symbol,quantity,buyPrice,buyDate
```

Les règles visibles dans le tutoriel sont notamment :

- `symbol` : symbole boursier officiel ;
- `quantity` : nombre entier de titres ;
- `buyPrice` : prix moyen d’achat en euros avec un point comme séparateur décimal ;
- `buyDate` : date d’achat au format `YYYY-MM-DD`.

Si une information est inconnue, l’utilisateur doit vérifier le fichier avant de l’importer.

Scalia ne doit pas inventer une donnée financière manquante.

## Exemple de fichier CSV

```csv
symbol,quantity,buyPrice,buyDate
TTE.PA,130,54.17,2024-01-15
BNP.PA,70,60.76,2024-02-10
```

Cet exemple sert uniquement à illustrer la structure attendue.

## Données visibles pour une position

Une fois importée ou ajoutée, une position peut afficher :

- le symbole ;
- le nom de la société ;
- le secteur ;
- la quantité ;
- le prix de revient unitaire ;
- le cours actuel ;
- l’évolution quotidienne ;
- le montant investi ;
- la valeur actuelle ;
- la plus-value ou moins-value ;
- la performance en pourcentage ;
- le rendement du dividende ;
- le poids de la ligne dans le portefeuille.

## Modifier une position

Une position peut être modifiée depuis les actions associées à la ligne lorsque cette option est disponible.

## Supprimer une position

Une position peut être supprimée depuis les actions associées à la ligne lorsque cette option est disponible.

## Relation avec les dividendes

Les positions enregistrées alimentent le suivi des dividendes.

Les estimations et analyses de dividendes reposent sur les lignes présentes dans le portefeuille.

## Points importants

- Il n’existe pas de connexion automatique aux banques ou aux brokers.
- L’utilisateur reste responsable des informations importées.
- Le fichier CSV doit respecter le format attendu.
- L’intelligence artificielle sert uniquement d’aide à la création du fichier CSV.
- Les données générées par l’IA doivent être vérifiées avant l’import.
- L’import se fait manuellement depuis la page Portfolio.

## Limites documentaires

Les captures ne permettent pas de confirmer :

- la taille maximale du fichier CSV ;
- le nombre maximal de lignes ;
- les formats de fichiers autres que CSV ;
- la gestion des doublons ;
- le comportement exact en cas d’erreur d’import ;
- la mise à jour automatique des quantités après une vente ;
- la liste complète des marchés pris en charge ;
- les éventuelles restrictions Free ou Premium.

Scalia ne doit pas inventer ces informations.

# Questions utilisateurs

- Comment ajouter une action dans mon portefeuille ?
- Comment ajouter une position ?
- Peut-on importer plusieurs positions ?
- Quel format CSV faut-il utiliser ?
- Peut-on importer une capture d’écran directement ?
- L’intelligence artificielle peut-elle créer le CSV ?
- Quel prompt utiliser pour générer le CSV ?
- Scalrise se connecte-t-il à mon broker ?
- Peut-on synchroniser un compte Boursobank ?
- Peut-on connecter Trade Republic ?
- Peut-on connecter Degiro ?
- Peut-on connecter Fortuneo ?
- Les positions sont-elles importées automatiquement ?
- Dois-je ajouter mes positions manuellement ?
- Quelles colonnes doit contenir le fichier CSV ?
- Quel format utiliser pour la date d’achat ?
- Peut-on modifier une position ?
- Peut-on supprimer une position ?
- Comment corriger une position erronée ?
- Les positions servent-elles au calcul des dividendes ?
- Que se passe-t-il si une donnée est manquante ?
- Peut-on importer les positions avec un fichier CSV ?
- Où se trouve l’import CSV ?

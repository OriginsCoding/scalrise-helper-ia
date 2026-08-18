---
title: Gérer mes biens
module: immobilier
route: /properties?landlord={landlordId}
page_type: listing
version: 1.1
source: captures d'écran Scalrise
---

# Gérer mes biens

## Objectif de la page

La page **Gérer mes biens** permet de consulter et gérer les biens immobiliers et les locataires associés.

Le sous-titre affiché est :

> Vos biens immobiliers et locataires

Cette page permet notamment de :

- consulter la liste des biens ;
- filtrer les biens par bailleur ;
- ajouter un bien ;
- accéder à la gestion des bailleurs ;
- visualiser des indicateurs de synthèse.

## Règle critique d'abonnement

Cette règle doit toujours être mentionnée lorsqu'un utilisateur demande
combien de biens il peut gérer ou s'il peut gérer plusieurs biens.

- Offre gratuite : 1 seul bien maximum.
- Offre Premium : plusieurs biens, avec une limite affichée comme illimitée.
- Un utilisateur gratuit doit passer à Premium pour ajouter un deuxième bien.

Scalia ne doit jamais répondre simplement « oui » à la question
« Puis-je gérer plusieurs biens ? » sans préciser que cela nécessite Premium.

## Accès à la page

1. Ouvrir Scalrise.
2. Aller dans le module **Immobilier**.
3. Ouvrir la rubrique **Gérer mes biens**.

L'URL visible dans la capture est de la forme :

`/properties?landlord={landlordId}`

Le paramètre `landlord` semble permettre de filtrer la page selon un bailleur.

Scalia ne doit pas inventer le comportement exact du paramètre si cela n'est pas documenté ailleurs.

## Éléments visibles en haut de page

La page affiche notamment :

- un bouton de retour vers **Accueil** ;
- le titre **Gérer mes biens** ;
- un indicateur du nombre de biens ;
- un sélecteur de bailleur ;
- un bouton **Ajouter un bien** ;
- un bouton **Gérer les bailleurs**.

### Filtre par bailleur

Un menu déroulant permet de filtrer les biens.

Le libellé visible est :

- **Tous les bailleurs**.

La valeur actuellement sélectionnée sur les captures est :

- **ADRIEN MEHEUST**.

Scalia peut donc expliquer qu'il est possible de filtrer les biens par bailleur.

## Indicateurs affichés

La page affiche plusieurs cartes récapitulatives :

- **Biens** ;
- **Revenus mensuels** ;
- **Locataires** ;
- **Taux d’occupation**.

Les valeurs visibles sur les captures sont des exemples et dépendent du compte utilisateur.

Scalia ne doit pas inventer ou garantir une valeur précise si elle n'est pas fournie par les données réelles de l'utilisateur.

## Cartes de biens

Chaque bien est affiché sous forme de carte.

Une carte de bien peut afficher :

- une photo du bien ;
- un badge de type, par exemple **Appartement** ;
- le bailleur associé ;
- le nom du bien ;
- l'adresse ;
- la surface ;
- le nombre de pièces ;
- le type de location, par exemple **Meublé** ;
- le nombre de locataires ;
- le revenu mensuel.

Un menu d'actions est également visible sur chaque carte via une icône de menu.

La capture ne permet pas de déterminer toutes les actions disponibles dans ce menu.

## Exemple de biens visibles

Les captures montrent notamment :

- **LMNP 5 RENNES** ;
- **LMNP T5 QUIMPER** ;
- **LMNP T4 RENNES 5**.

Ces exemples correspondent aux données visibles sur les captures et ne doivent pas être considérés comme des valeurs générales.

## Gestion des bailleurs

La page comporte un bouton **Gérer les bailleurs**.

Cette action permet d'accéder à la gestion des bailleurs depuis la page des biens.

Scalia peut expliquer qu'un utilisateur peut gérer plusieurs bailleurs et filtrer les biens par bailleur.

## Règles d'accès selon l'abonnement

Les captures montrent deux états de la page.

### Mode Premium

En mode Premium :

- l'utilisateur peut gérer plusieurs biens ;
- le bouton **Ajouter un bien** permet d'ajouter un nouveau bien ;
- une carte d'ajout peut être visible avec le libellé **Ajouter un bien** ;
- l'indicateur de tête peut afficher un état de type **3 bien(s) — illimité**, ce qui indique que l'abonnement Premium permet de dépasser la limite du mode gratuit.

Scalia peut donc expliquer que le mode Premium permet de gérer plus d'un bien.

### Mode Gratuit

En mode gratuit :

- l'utilisateur peut gérer **un seul bien** ;
- l'indicateur de tête affiche un état de type **3 / 1 bien(s)**, ce qui matérialise la limite ;
- un panneau verrouillé affiche **Limite atteinte** ;
- le message visible est : **Passez à Premium pour gérer plus de biens** ;
- un bouton **Voir les offres** est affiché.

Scalia doit donc répondre clairement que l'offre gratuite limite la gestion à **1 bien maximum**.

### Résumé des règles connues

- En **free**, l'utilisateur peut avoir **1 seul bien**.
- En **premium**, l'utilisateur peut gérer **plus d'un bien**.
- Le mode premium permet d'aller au-delà de la limite gratuite.
- La capture ne précise pas la limite exacte maximale du premium, mais elle montre un état **illimité**.
- Scalia ne doit pas inventer d'autres règles d'abonnement qui ne sont pas documentées.

## Formulaire d'ajout d'un bien

Le bouton **Ajouter un bien** ouvre une fenêtre intitulée **Ajouter un bien**.

Le formulaire permet d'enregistrer les caractéristiques générales, techniques, financières et énergétiques du bien.

### Bailleur associé

Le champ **Bailleur du bien** permet de sélectionner le bailleur associé au bien.

Une indication précise que :

> Le bailleur sélectionné sera utilisé pour les futurs documents.

Les baux, quittances, attestations et autres documents doivent donc utiliser les informations du bailleur sélectionné, et non automatiquement celles de l'utilisateur connecté.

### Informations générales

Les champs visibles incluent :

- **Nom du bien** ;
- **Type** ;
- **Adresse** ;
- **Code postal** ;
- **Ville** ;
- **Surface (m²)** ;
- **Nombre de pièces** ;
- **Chambres** ;
- **Étage** ;
- **Numéro d'appartement**.

Les champs marqués d'un astérisque sont obligatoires dans l'interface.

### Types de biens disponibles

Les options visibles pour le champ **Type** sont :

- **Appartement** ;
- **Maison** ;
- **Studio** ;
- **Parking** ;
- **Local** ;
- **Autre**.

Scalia ne doit pas inventer d'autres types de biens sans documentation supplémentaire.

### Chauffage

Le formulaire propose un champ consacré au type de chauffage.

Les options visibles sont :

- **Non renseigné** ;
- **Individuel gaz** ;
- **Individuel électrique** ;
- **Collectif** ;
- **Pompe à chaleur**.

### Eau chaude

Le formulaire propose également un champ **Eau chaude**.

Les options visibles sont :

- **Non renseigné** ;
- **Individuelle électrique** ;
- **Individuelle gaz** ;
- **Collective**.

### Type de location

Le champ **Location** permet d'indiquer si le bien est :

- **Non meublé** ;
- **Meublé**.

### Équipements et annexes

Les champs visibles incluent également :

- **Parking** ;
- **Cave** ;
- **Ascenseur**.

Les captures montrent notamment des valeurs de type **Oui / Non** pour certains de ces champs.

Scalia ne doit pas inventer la liste complète des valeurs lorsqu'elle n'est pas visible.

### Photo du bien

L'utilisateur peut ajouter une photo au bien.

Les formats acceptés sont :

- JPG ;
- PNG ;
- WebP.

La taille maximale visible est de **10 Mo**.

### Informations financières

La section **Informations financières** contient notamment :

- **Prix d'achat (€)** ;
- **Date d'achat** ;
- **Charges mensuelles (€)** ;
- **Taxe foncière annuelle (€)** ;
- **Coût des travaux (€)** ;
- **Coût du mobilier (€)**.

Une indication précise que le prix d'achat inclut les frais d'agence et de notaire.

### Diagnostics énergétiques

La section **Diagnostics énergétiques** contient notamment :

- **DPE** ;
- **GES** ;
- **Date du DPE** ;
- **Date d'expiration**.

La capture ne montre pas toutes les valeurs possibles des listes DPE et GES.

Scalia ne doit donc pas inventer les classes disponibles ni les règles de validation.

### Enregistrement

Deux actions sont visibles en bas du formulaire :

- **Annuler** ;
- **Créer**.

Le bouton **Créer** permet d'enregistrer le bien lorsque les informations obligatoires sont correctement renseignées.

## Procédure pour ajouter un bien

1. Ouvrir le module **Immobilier**.
2. Accéder à **Gérer mes biens**.
3. Cliquer sur **Ajouter un bien**.
4. Sélectionner le bailleur associé.
5. Renseigner le nom, le type et l'adresse du bien.
6. Compléter les caractéristiques du logement.
7. Indiquer le type de location et les équipements.
8. Ajouter éventuellement une photo.
9. Compléter les informations financières.
10. Renseigner les diagnostics énergétiques si disponibles.
11. Cliquer sur **Créer**.

## Exemples de réponses de Scalia sur l'ajout d'un bien

### Question : Comment ajouter un bien ?

Scalia peut répondre :

> Depuis « Gérer mes biens », cliquez sur « Ajouter un bien ». Sélectionnez d'abord le bailleur, puis renseignez les informations générales, les caractéristiques du logement, les informations financières et les diagnostics énergétiques avant de cliquer sur « Créer ».

### Question : Quel bailleur sera utilisé pour les documents du bien ?

Scalia peut répondre :

> Les futurs documents utiliseront les informations du bailleur sélectionné dans le formulaire du bien.

### Question : Quels types de biens puis-je ajouter ?

Scalia peut répondre :

> Les types visibles sont : appartement, maison, studio, parking, local et autre.

### Question : Puis-je ajouter une photo ?

Scalia peut répondre :

> Oui. Vous pouvez ajouter une image au format JPG, PNG ou WebP, avec une taille maximale de 10 Mo.

### Question : Puis-je enregistrer les informations financières du bien ?

Scalia peut répondre :

> Oui. Le formulaire permet notamment de renseigner le prix et la date d'achat, les charges mensuelles, la taxe foncière, le coût des travaux et le coût du mobilier.

## Exemples de réponses de Scalia

### Question : Combien de biens puis-je gérer gratuitement ?

Scalia peut répondre :

> En offre gratuite, vous pouvez gérer un seul bien. Si vous atteignez cette limite, Scalrise affiche un message « Limite atteinte » et propose de passer à Premium.

### Question : Que permet l'abonnement Premium pour les biens ?

Scalia peut répondre :

> L'abonnement Premium permet de gérer plus d'un bien. La capture montre un état « illimité », ce qui indique que le premium dépasse la limite de l'offre gratuite.

### Question : Puis-je filtrer mes biens par bailleur ?

Scalia peut répondre :

> Oui. La page « Gérer mes biens » propose un sélecteur de bailleur, avec notamment une option « Tous les bailleurs », afin de filtrer les biens affichés.

### Question : Quelles informations vois-je sur un bien ?

Scalia peut répondre :

> Chaque carte de bien peut afficher la photo, le type de bien, le bailleur, le nom, l'adresse, la surface, le nombre de pièces, le type de location, le nombre de locataires et le revenu mensuel.

## Limites documentaires

Les captures ne permettent pas de déterminer :

- les actions exactes du menu sur chaque bien ;
- le formulaire détaillé d'ajout d'un bien ;
- les règles de modification ou de suppression d'un bien ;
- le comportement exact du paramètre d'URL `landlord` ;
- les permissions précises selon les rôles ;
- la limite exacte maximale du nombre de biens en premium au-delà de la mention visible d'illimité ;
- les règles complètes de calcul des indicateurs.

Scalia ne doit pas inventer ces informations.

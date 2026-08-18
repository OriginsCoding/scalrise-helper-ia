---
title: Mes bailleurs
module: immobilier
route: /properties/landlords
page_type: management
version: 1.0
source: captures d'écran Scalrise
---

# Mes bailleurs

## Objectif de la page

La page **Mes bailleurs** permet de gérer les bailleurs utilisés par les biens, les baux, les quittances et les attestations.

Le sous-titre affiché est :

> Gérez les bailleurs utilisés par vos biens, baux, quittances et attestations.

Cette page permet notamment de :

- consulter la liste des bailleurs ;
- ajouter un bailleur ;
- modifier un bailleur existant ;
- définir un bailleur par défaut ;
- archiver un bailleur ;
- revenir à la page des biens ;
- ouvrir la liste des biens liés à un bailleur.

## Accès à la page

1. Ouvrir Scalrise.
2. Aller dans le module **Immobilier**.
3. Ouvrir la rubrique **Gérer les bailleurs**.

L'URL visible sur les captures est :

`/properties/landlords`

## Structure de la page

La page est divisée en deux zones principales :

- à gauche, la liste des bailleurs ;
- à droite, un panneau de formulaire intitulé **Modifier le bailleur**.

Un bouton **Ajouter un bailleur** est visible en haut à droite.

Un lien **Retour aux biens** est visible en haut à gauche.

## Liste des bailleurs

Chaque bailleur est affiché sous forme de carte.

Une carte de bailleur peut afficher :

- le nom ou le libellé du bailleur ;
- un badge **Par défaut** ;
- un badge **Archivé** ;
- le type de bailleur ;
- des informations fiscales ou d'activité ;
- l'adresse du bailleur ;
- des actions rapides.

### Actions visibles sur une carte

Selon la capture, les actions suivantes peuvent être proposées :

- **Voir les biens** ;
- **Modifier** ;
- **Archiver**.

La carte d'un bailleur archivé affiche au minimum l'action **Modifier**.

La capture ne permet pas de confirmer si toutes les autres actions restent disponibles pour un bailleur archivé.

## Types de bailleurs visibles

Les captures montrent deux grands types de bailleurs :

- **Personne physique** ;
- **Société**.

Scalia peut donc expliquer qu'un utilisateur peut gérer plusieurs types de bailleurs.

## Qui peut être un bailleur ?

Dans Scalrise, le bailleur est une entité métier distincte de l'utilisateur connecté.

Un bailleur peut être :

- l'utilisateur lui-même en tant que personne physique ;
- une société ou une personne morale liée à l'utilisateur, par exemple une SCI, une SARL de famille, une SARL, une SAS ou une SASU ;
- un tiers pour lequel l'utilisateur gère des biens locatifs.

Le bailleur n'est donc pas nécessairement la personne connectée à Scalrise.

Lorsqu'un utilisateur gère un bien pour le compte d'un tiers, les informations utilisées pour les baux, quittances, attestations et autres documents doivent être celles du bailleur associé au bien, et non automatiquement celles de l'utilisateur connecté.

Scalia doit distinguer clairement :

- **Utilisateur Scalrise** : personne connectée à la plateforme ;
- **Gestionnaire** : personne qui administre le bien dans Scalrise ;
- **Bailleur** : personne physique ou morale juridiquement associée au bien et utilisée dans les documents.

Une même personne peut cumuler plusieurs rôles, mais ce n'est pas obligatoire.

## Exemple de statuts visibles

Les captures montrent notamment :

- un bailleur **Par défaut** ;
- un bailleur **Archivé**.

Scalia peut expliquer qu'un bailleur peut être défini par défaut et qu'un bailleur peut être archivé.

## Ajouter un bailleur

Le bouton **Ajouter un bailleur** permet d'ouvrir la création d'un nouveau bailleur.

L'ajout et la modification utilisent le **même formulaire**.

Scalia peut donc expliquer que l'écran de création et l'écran de modification reposent sur la même structure de champs, adaptée selon le type de bailleur sélectionné.

## Modifier un bailleur

Le panneau de droite est intitulé :

> Modifier le bailleur

Une phrase d'aide est visible :

> Les nouveaux documents utiliseront ces informations.

Cela signifie que les informations du bailleur sont utilisées dans les documents générés par Scalrise.

Le formulaire dépend du **type de bailleur** sélectionné.

Un sélecteur **Type de bailleur** est visible.

Un interrupteur permet de :

- **Définir comme bailleur par défaut**.

Des boutons **Annuler** et **Enregistrer** sont visibles en bas du formulaire.

## Formulaire pour une société

Quand le type de bailleur est **Société**, les sections visibles sont les suivantes.

### Société

Les champs visibles incluent notamment :

- **Raison sociale** ;
- **Date de création** ;
- **Nom commercial** ;
- **Forme juridique** ;
- **SIREN** ;
- **SIRET** ;
- **Régime fiscal** ;
- **Capital social**.

#### Valeurs visibles pour la forme juridique

Les options visibles sont :

- **SCI** ;
- **SARL de famille** ;
- **SARL** ;
- **SAS** ;
- **SASU** ;
- **Autre**.

#### Valeurs visibles pour le régime fiscal d'une société

Les options visibles sont :

- **Impôt sur le revenu** ;
- **Impôt sur les sociétés** ;
- **Autre**.

### Représentant légal

Les champs visibles incluent notamment :

- **Prénom** ;
- **Nom** ;
- **Qualité**.

### Siège social

Les champs visibles incluent notamment :

- **Libellé affiché** ;
- **Adresse du siège social** ;
- **Code postal du siège social** ;
- **Ville du siège social**.

### Coordonnées

Les champs visibles incluent notamment :

- **Email** ;
- **Téléphone**.

## Formulaire pour une personne physique

Quand le type de bailleur est **Personne physique**, les sections visibles sont les suivantes.

### Identité

Les champs visibles incluent notamment :

- **Prénom** ;
- **Nom** ;
- **Date de naissance** ;
- **Ville de naissance**.

### Activité locative

Les champs visibles incluent notamment :

- **Type de location** ;
- **Statut fiscal** ;
- **Régime fiscal** ;
- **SIREN**.

#### Valeurs visibles pour le statut fiscal

Les options visibles sont :

- **Aucun** ;
- **LMNP** ;
- **LMP**.

#### Valeurs visibles pour le régime fiscal d'une personne physique

Les options visibles sont :

- **Régime réel BIC** ;
- **Micro-BIC** ;
- **Régime réel foncier** ;
- **Micro-foncier** ;
- **Autre**.

### Coordonnées et adresse

Les champs visibles incluent notamment :

- **Libellé affiché** ;
- **Adresse** ;
- **Code postal** ;
- **Ville** ;
- **Email** ;
- **Téléphone**.

La capture montre aussi que le type de location peut être, par exemple, **Meublée**, et que le statut fiscal peut être, par exemple, **LMNP**.

## Règles métier visibles

Les captures permettent d'établir les règles suivantes :

- un utilisateur peut gérer plusieurs bailleurs ;
- un bailleur peut être de type **Personne physique** ou **Société** ;
- un bailleur peut être l'utilisateur lui-même, une personne morale liée à l'utilisateur ou un tiers ;
- le bailleur est distinct de l'utilisateur connecté et du gestionnaire ;
- un utilisateur peut gérer des biens locatifs pour le compte d'autrui ;
- un bailleur peut être défini comme **bailleur par défaut** ;
- un bailleur peut être **archivé** ;
- l'ajout et la modification d'un bailleur utilisent le **même formulaire** ;
- les informations du bailleur associé au bien sont utilisées pour les nouveaux documents ;
- la page des biens peut être filtrée ou liée aux bailleurs, via l'action **Voir les biens**.

Scalia ne doit pas inventer d'autres règles de validation si elles ne sont pas documentées.

## Exemples de réponses de Scalia

### Question : Puis-je avoir plusieurs bailleurs dans Scalrise ?

Scalia peut répondre :

> Oui. La page « Mes bailleurs » permet de gérer plusieurs bailleurs, par exemple une personne physique et une société.

### Question : Le bailleur doit-il être la personne connectée ?

Scalia peut répondre :

> Non. Le bailleur peut être l'utilisateur lui-même, une société liée à l'utilisateur ou un tiers pour lequel il gère un bien locatif.

### Question : Puis-je gérer un bien pour le compte d'un tiers ?

Scalia peut répondre :

> Oui. Scalrise permet de distinguer l'utilisateur connecté, le gestionnaire du bien et le bailleur. Les documents utilisent les informations du bailleur associé au bien.

### Question : Quels types de bailleurs puis-je créer ?

Scalia peut répondre :

> La documentation visible montre au moins deux types de bailleurs : personne physique et société.

### Question : L'ajout et la modification utilisent-ils le même formulaire ?

Scalia peut répondre :

> Oui. D'après la documentation disponible, l'ajout et la modification d'un bailleur utilisent le même formulaire, avec des champs qui s'adaptent selon le type de bailleur sélectionné.

### Question : Puis-je définir un bailleur par défaut ?

Scalia peut répondre :

> Oui. Le formulaire de bailleur propose une option « Définir comme bailleur par défaut ».

### Question : Puis-je archiver un bailleur ?

Scalia peut répondre :

> Oui. La liste des bailleurs montre qu'un bailleur peut être archivé, et une action « Archiver » est visible sur la carte d'un bailleur.

### Question : Quelles informations dois-je renseigner pour une société ?

Scalia peut répondre :

> Pour une société, Scalrise demande notamment la raison sociale, la date de création, la forme juridique, le SIREN, le SIRET, le régime fiscal, le capital social, les informations du représentant légal et l'adresse du siège social.

### Question : À quoi servent les informations du bailleur ?

Scalia peut répondre :

> Les informations du bailleur sont utilisées pour les nouveaux documents, notamment les baux, quittances et attestations.

## Limites documentaires

Les captures ne permettent pas de déterminer :

- les règles exactes de validation de chaque champ ;
- les champs obligatoires selon tous les cas métier ;
- les effets précis de l'archivage ;
- si un bailleur archivé peut encore être associé à de nouveaux biens ;
- les règles de suppression d'un bailleur ;
- si certaines formes juridiques déclenchent des champs supplémentaires ;
- les messages de confirmation ou d'erreur ;
- les permissions précises selon les rôles utilisateurs ;
- les valeurs complètes de tous les menus déroulants au-delà des options visibles sur les captures.

Scalia ne doit pas inventer ces informations.

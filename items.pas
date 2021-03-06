(* Items and objects in the game world *)
unit items;

{$mode objfpc}{$H+}

interface

uses
  Graphics, globalutils, map,
  (* Import the items *)
  ale_tankard, dagger, leather_armour1, cloth_armour1, basic_club, wine_flask;

type
  (* Item types = drink, weapon, armour, missile *)

  (* Store information about items *)
  Item = record
    (* Unique ID *)
    itemID: smallint;
    (* Item name & description *)
    itemName, itemDescription: shortstring;
    (* drink, weapon, armour, missile *)
    itemType: shortstring;
    (* Used for lookup table *)
    useID: smallint;
    (* Position on game map *)
    posX, posY: smallint;
    (* Character used to represent item on game map *)
    glyph: char;
    (* Is the item in the players FoV *)
    inView: boolean;
    (* Is the item on the map *)
    onMap: boolean;
    (* Displays a message the first time item is seen *)
    discovered: boolean;
  end;


var
  itemList: array of Item;
  itemAmount, listLength: smallint;
  aleTankard, crudeDagger, leatherArmour1, clothArmour, woodenClub, wineFlask: TBitmap;

(* Load item textures *)
procedure setupItems;
(* Generate list of items on the map *)
procedure initialiseItems;
(* Draw item on screen *)
procedure drawItem(c, r: smallint; glyph: char);
(* Is there an item at coordinates *)
function containsItem(x, y: smallint): boolean;
(* Get name of item at coordinates *)
function getItemName(x, y: smallint): shortstring;
(* Get description of item at coordinates *)
function getItemDescription(x, y: smallint): shortstring;
(* Redraw all items *)
procedure redrawItems;
(* Execute useItem procedure *)
procedure lookupUse(x: smallint; equipped: boolean);

implementation

procedure setupItems;
begin
  aleTankard := TBitmap.Create;
  aleTankard.LoadFromResourceName(HINSTANCE, 'ALE1');
  wineFlask := TBitmap.Create;
  wineFlask.LoadFromResourceName(HINSTANCE, 'ALE2');
  crudeDagger := TBitmap.Create;
  crudeDagger.LoadFromResourceName(HINSTANCE, 'DAGGER');
  leatherArmour1 := TBitmap.Create;
  leatherArmour1.LoadFromResourceName(HINSTANCE, 'LEATHER_ARMOUR1');
  woodenClub := TBitmap.Create;
  woodenClub.LoadFromResourceName(HINSTANCE, 'BASIC_CLUB');
  clothArmour := TBitmap.Create;
  clothArmour.LoadFromResourceName(HINSTANCE, 'CLOTH_ARMOUR1');
end;

procedure initialiseItems;
begin
  itemAmount := 0;
  // initialise array
  SetLength(itemList, 0);
end;

procedure drawItem(c, r: smallint; glyph: char);
begin { TODO : When more items are created, swap this out for a CASE statement }
  if (glyph = '!') then
    drawToBuffer(mapToScreen(c), mapToScreen(r), aleTankard)
  else if (glyph = '2') then
    drawToBuffer(mapToScreen(c), mapToScreen(r), crudeDagger)
  else if (glyph = '3') then
    drawToBuffer(mapToScreen(c), mapToScreen(r), leatherArmour1)
  else if (glyph = '4') then
    drawToBuffer(mapToScreen(c), mapToScreen(r), woodenClub)
  else if (glyph = '5') then
    drawToBuffer(mapToScreen(c), mapToScreen(r), clothArmour)
  else if (glyph = '6') then
    drawToBuffer(mapToScreen(c), mapToScreen(r), wineFlask);
end;

function containsItem(x, y: smallint): boolean;
var
  i: smallint;
begin
  Result := False;
  for i := 1 to itemAmount do
  begin
    if (itemList[i].posX = x) and (itemList[i].posY = y) then
      Result := True;
  end;
end;

function getItemName(x, y: smallint): shortstring;
var
  i: smallint;
begin
  for i := 1 to itemAmount do
  begin
    if (itemList[i].posX = x) and (itemList[i].posY = y) then
      Result := itemList[i].itemName;
  end;
end;

function getItemDescription(x, y: smallint): shortstring;
var
  i: smallint;
begin
  for i := 1 to itemAmount do
  begin
    if (itemList[i].posX = x) and (itemList[i].posY = y) then
      Result := itemList[i].itemDescription;
  end;
end;

procedure redrawItems;
var
  i: smallint;
begin
  for i := 1 to itemAmount do
  begin
    if (itemList[i].inView = True) and (itemList[i].onMap = True) then
    begin
      drawItem(itemList[i].posX, itemList[i].posY, itemList[i].glyph);
    end;
  end;
end;

procedure lookupUse(x: smallint; equipped: boolean);
begin
  case x of
    1: ale_tankard.useItem;
    2: dagger.useItem(equipped);
    3: leather_armour1.useItem(equipped);
    4: basic_club.useItem(equipped);
    5: cloth_armour1.useItem(equipped);
    6: wine_flask.useItem;
  end;
end;

end.

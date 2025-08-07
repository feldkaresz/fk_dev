program filmlista;

uses crt;

type   filmtip = record
       id: integer;
       nev: string[30];
       foszerep: string[32];
       media: string[4];
       kell: boolean;

       end;

var szam: byte;
    i_or_n: char;
    db: integer;
    filmek: file of filmtip;
    uj: file of filmtip;
    max: integer;
    f, g: filmtip;
    eredetiszin: byte;
    tsz,bmw, msz, mn, n: integer;
    pozicio: longint;

{-------------------------}
procedure menu;

     begin
          clrscr;
          gotoxy(32,5); write('Filmnyilv†ntart†s');
          gotoxy(30,7); Write('---------------------');
          gotoxy(30,3); write('---------------------');
          gotoxy(50,4); write('|');
          gotoxy(50,5); write('|');
          gotoxy(50,6); write('|');
          gotoxy(30,6); write('|');
          gotoxy(30,5); write('|');
          gotoxy(30,4); write('|');

          gotoxy(30,11); write('MenÅ:'); write('    1: Èj FelvÇtel');
          gotoxy(37,15); write('  3: List†z†s');
          gotoxy(37,13); write('  2: M¢dos°t†s');
          gotoxy(37,17); write('  4: TîrlÇs');
          gotoxy(37,19); write('  5: Sz˚rÇs');
          gotoxy(37,21); write('  6: Help');
          gotoxy(37,23); write('  7: KilÇpÇs');
          gotoxy(53,23); write('  V†lassz egy sz†mot:  '); readln(szam);

     end;{procedure menu}

{--------------------------}
procedure ered_szin;
          begin
               window(1,1,80,25);
               textbackground(blue);
               textcolor(white);
               clrscr;
          end;


{------------------------}
procedure figyelem;

          begin
               window(28,8,55,10);
               textbackground(red);
               textcolor(white);
               clrscr;
          end;


{---------------------------}
procedure kilep;

          begin
               figyelem;
               gotoxy(3,2); write('Biztos kilÇpsz?   i/n  ');
               {gotoxy(38, 15); }
               readln(i_or_n);
               if (i_or_n ='i') then
                  begin
                       window(1,1,80,25);
                       textbackground(black);
                       textcolor(white);
                       clrscr;
                       halt;
                  end

               else
                   begin
                        ered_szin;
                        menu;
                   end;
          end;{procedure kilep}


{------------------------}
procedure hozzaad_ablak;
          begin
               window(22,8,60,17);
               textbackground(green);
               textcolor(white);
               clrscr;
          end;


{-----------------------}
procedure hozzaad;
          const vege = '';
          var s: char;
              i: integer;

          begin
               assign(filmek, 'film.dat');
               reset(filmek);
               hozzaad_ablak;
               repeat
                     hozzaad_ablak;
                     reset(filmek);
                     seek(filmek, filesize(filmek));
                     f.id:=filesize(filmek);
                     {beviteli folyamat ismÇtlÇse}

                     inc(f.id);
                     writeln('Azonos°t¢: ',f.id,'   ','(C°mnÇl <ENTER>: kilÇp)');
                     writeln('C°m: ');
                     readln(f.nev);
                     if (f.nev = '') then
                        begin
                             dec(f.id);
                             window(1,1,80,25);
                             textbackground(blue);
                             textcolor(white);
                             clrscr;

                        end
                     else
                         begin
                              writeln('Fãszereplã: '); readln(f.foszerep);
                              writeln('MÇdia t°pus: '); readln(f.media);
                              f.kell:= true;
                              write(filmek, f);
                              writeln('M†sikat?   i/n   '); readln(s); clrscr;

                         end;

               until (s = 'n') or (f.nev='');
               close(filmek);
               textattr:= eredetiszin;
               window(1,1,80,25);      {eredeti menÅkÇp vissza†ll°t†sa}
               clrscr;
               menu;

          end;{hozzaad}

{------------------------}
procedure listafej;
          begin
                 clrscr;
               gotoxy(39,1); writeln('Filmlista:');
               gotoxy(2,2); write('ID:      C°m:');
               gotoxy(40,2); write('Fãszereplã:                    mÇdia:');
               gotoxy(3,3); write('-------------------------------------');
               gotoxy(40,3); writeln('-------------------------------------');

          end;{listafej vÇge}


{--------------------------}
procedure listazas;
          var lista: text;
              lanc : string;
              sor: integer;
              ans: char;

          begin

             repeat
               listafej;
               assign(filmek, 'film.dat');
               reset(filmek);
               seek(filmek, 0);
              { seek(filmek, 0);}

               begin
               for sor:=1 to filesize(filmek) do
                   begin
                        if whereY = 24 then  {20 soronkÇnt lapoz†s}
                           begin
                                writeln;
                                write('    Lista gîrgetÇse: <ENTER>,');
                               { write(' KilÇpÇs: <ESC>');  }

                                repeat
                                until (readkey = #13);
                                listafej;


                           end;
                        read(filmek, f);
                        with f do
                             begin
                                  gotoxy(2, whereY); write(id);
                                  gotoxy(7, whereY); write(nev);
                                  gotoxy(40, whereY); write(foszerep);
                                  gotoxy(75, whereY); write(media);
                                  writeln;

                             end;
                   end;
               end;
gotoxy(5,25); write('Lista gîrgetÇse: <ENTER>, KilÇpÇs: <ESC>');
                close(filmek);
             until readkey = #27;

             menu;

          end;
{end procedure listazas}


{---------------------------}
procedure nagyablak;
          begin
               window(3,5,77,15);
               textbackground(5);
               textcolor(white);
               clrscr;
          end;


{nagyablak vÇge}


{-------------------------}
function ker_eredm(id: integer;  var poz: longint): boolean;

var van: boolean;

          begin

               assign(filmek, 'film.dat');
               reset(filmek);
               seek(filmek,0);
               van:= false;

               while not eof(filmek) and not van do
                     begin
                          read(filmek, f);
                          van:= ((f.id = tsz) and f.kell);

                     end;
               poz:= filepos(filmek);

               if van then
                  dec(poz);
               ker_eredm:= van;
               close(filmek);
          end;
{ker_eredm fÅggvÇny vÇge}


{--------------------------}
procedure torol;

var v, ja: char;
    max: integer;
    e: integer;

          begin
             repeat
               reset(filmek);

               max:=filesize(filmek);
               nagyablak;
               gotoxy(29,3);
               writeln('ôsszes film: ', max); writeln;
               gotoxy(5,5);
               write('Tîrlendã film sz†ma:   '); readln(tsz); writeln;
               if ker_eredm(n, pozicio) then
                  begin
                       writeln(f.id,'  ',f.nev,'  ',f.foszerep,'   ',f.media);
                       writeln;
                       gotoxy(5,9);
                       write('Biztos tîrlîd?   (nem visszavonhat¢)   i/n   ');
                       readln(v);
                          if (v='i') then
                             begin
                                  f.kell:=false;

                                  assign(filmek, 'film.dat');
                                  reset(filmek);
                                  seek(filmek, pozicio);

                                  write(filmek, f);
                                  assign(uj, 'uj.dat');
                                  rewrite(uj);
                                  seek(filmek, 0);
                                  while not eof(filmek) do
                                        begin
                                          read(filmek, f);
                                          if f.kell and (f.id < tsz) then
                                             write(uj, f)
                                          else
                                              if f.kell and (f.id > tsz) then
                                               begin
                                                    dec(f.id);
                                                    write(uj, f);
                                               end;

                                        end;

                                  close(filmek);
                                  erase(filmek);
                                  close(uj);
                                  rename(uj, 'film.dat');

                             end;
                  end
               else
                   begin
                        figyelem;
                        writeln;
                        writeln('  Nincs ilyen sz†m£ film!'); readln;

                        reset(filmek);
                        nagyablak;

                   end;
          gotoxy(5,11);
          write('M†sikat?   i/n   ');
          readln(ja);
          until (ja='n');
          ered_szin;
          menu;
          end;

{end porcedure torol}



{---------------------------}
procedure modosit;

var v: integer;
    answ: char;


          begin
               assign(filmek, 'film.dat');
               reset(filmek);
               max:= filesize(filmek);

               repeat
               reset(filmek);
               nagyablak;

               gotoxy(29,5);
               writeln('ôsszes film:  ', max);
               gotoxy(7,7);
               write('M¢dos°tand¢ film sz†ma:   '); readln(tsz); writeln;
               if ker_eredm(bmw, pozicio) then
                  begin
                       clrscr;
                       writeln(f.id,'  ',f.nev,'  ',f.foszerep,'  ',f.media);

                       gotoxy(7,3);
                       writeln('Mit modos°tasz? ');
                       gotoxy(7,5);
                       writeln('1: Mindent    (ID-t nem lehet)');
                       gotoxy(7,6);
                       writeln('2: C°met');
                       gotoxy(7,7);
                       writeln('3: Fãszereplã nevÇt');
                       gotoxy(7,8);
                       writeln('4: MÇdia t°pus†t');
                       gotoxy(7,9);
                       writeln('5: MÇgse'); gotoxy(7,11);

                         readln(v);
                         case v of
                              1: begin
                                      clrscr;
                                      writeln(f.id,'  ',f.nev,'  ',f.foszerep,'  ',f.media);
                                      assign(uj, 'uj.dat');
                                      rewrite(uj);
                                      reset(filmek);
                                      seek(filmek, 0);
                                      while not eof(filmek) do
                                            begin
                                                 read(filmek, f);
                                                 if f.id<tsz then
                                                    write(uj, f);
                                            end;

                                      f.id:= tsz;
                                      gotoxy(14,3);
                                      writeln('Filmc°m:  ');
                                      gotoxy(23,3); readln(f.nev);
                                      gotoxy(11,5);
                                      writeln('Fãszereplã: ');
                                      gotoxy(23,5); readln(f.foszerep);
                                      gotoxy(16,7);
                                      writeln('MÇdia: ');
                                      gotoxy(23,7); readln(f.media);
                                      seek(filmek, filesize(uj));
                                      write(uj, f);
                                      while not eof(filmek) do
                                            begin
                                                 read(filmek, f);
                                                 if f.id>tsz then
                                                    write(uj, f);
                                            end;

                                      close(uj);
                                      erase(filmek);
                                      rename(uj, 'film.dat');

                                 end; {minden modositas}

                              2: begin
                                      clrscr;
                                      reset(filmek);
                                      gotoxy(7,5);
                                      writeln('KÇrem az £j c°met: ','(rÇgi: ',f.nev,')');
                                      gotoxy(15,7); readln(f.nev);
                                      seek(filmek, tsz-1);
                                      write(filmek, f);

                                 end; {csak c°m m¢dos°t†s}

                              3: begin
                                      clrscr;
                                      reset(filmek);
                                      gotoxy(7,5);
                                      writeln('KÇrem a fãszereplã nevÇt: ','(rÇgi: ',f.foszerep,')');
                                      gotoxy(15,7); readln(f.foszerep);
                                      seek(filmek, tsz-1);
                                      write(filmek, f);
                                 end;

                              4: begin
                                      clrscr;
                                      reset(filmek);
                                      gotoxy(7,5);
                                      writeln('KÇrem a mÇdia t°pus†t: ','(rÇgi: ',f.media,')');
                                      gotoxy(15,7); readln(f.media);
                                      seek(filmek, tsz-1);
                                      write(filmek, f);
                                 end;

                              5: begin
                                      {close(filmek);}
                                      ered_szin;

                                 end;

                              else
                              begin
                                   figyelem;
                                   writeln;
                                   writeln('   Csak 1 Çs 5 kîzîtt!!!');
                                   readln;
                                   nagyablak;

                              end;

                         end;


                  end

               else
                   begin
                        figyelem;
                        writeln;
                        writeln(' Nincs ilyen sz†m£ film!!!');
                        readln;
                        nagyablak;

                   end;
              { if v <> 5 then
                  begin }
                      nagyablak;
                      gotoxy(30,6); write('M†sikat?   i/n   ');
                      readln(answ);
                {  end; }

               until ((answ = 'n') {or (v=5))});
               ered_szin;
               menu;
          end;


{end procedure modosit}


{--------------------------}
procedure szures;

var vv: char;
    szv, n, sor: integer;
    med: string[4];

          begin
               repeat

               nagyablak;
               assign(filmek, 'film.dat');

               gotoxy(32,3); writeln('Mi szerint sz˚rjek?');
               gotoxy(15,5); writeln('1: ABC szerint sorbarendezÇs');
               gotoxy(15,6); writeln('2: Filmc°m keresÇse');
               gotoxy(15,7); writeln('3: Fãszereplã keresÇse');
               gotoxy(15,8); writeln('4: MÇdium szerinti keresÇs');
               gotoxy(15,9); writeln('5: MÇgsem  <MenÅ>'); writeln;
               gotoxy(20, whereY); write('V†lassz egy sz†mot:  '); readln(szv);

               case szv of
                  1: readln;

                  2: readln;

                  3: readln;

                  4: begin

                                clrscr;
                                gotoxy(30,6);
                                write('Keresett mÇdium:  '); readln(med);
                              repeat
                              n:= 0;
                                reset(filmek);
                                seek(filmek, 0);
                                ered_szin;
                                listafej;

                                for sor:=1 to filesize(filmek) do
                                    begin

                                         if whereY = 24 then  {20 sor lapoz†s}
                                            begin
                                                 writeln;
                                                 write('    Lista gîrgetÇse: <ENTER>,');
                                                 { write(' KilÇpÇs: <ESC>');  }
                                                  repeat
                                                  until (readkey = #13);
                                                  listafej;
                                            end;

                                         read(filmek, f);
                                         if f.media = med then
                                            begin
                                                 inc(n);
                                                 with f do
                                                      begin

                                                           gotoxy(2,whereY);
                                                           write(f.id);
                                                           gotoxy(7,whereY);
                                                           write(f.nev);
                                                           gotoxy(40,whereY);
                                                           write(f.foszerep);
                                                           gotoxy(75,whereY);
                                                           write(f.media);
                                                           writeln;
                                                      end;

                                            end;

                                    end;{for ciklus}

                                writeln;
                                writeln('keresett filmek sz†ma:  ',n);
                                gotoxy(33,25); write('GîrgetÇs: <ENTER>, KilÇpÇs: <ESC>');
                               until readkey = #27;


                                close (filmek);

                        {  until readkey = #27; }

                        {  clrscr;}

                     end; {4-es vÇge}


                  5: begin
                      end;

               else writeln('fuck you');

               end;{case}
               nagyablak;
               gotoxy(30,6);
               write('M†sikat?   i/n    '); readln(vv);
               {ered_szin; }
               until vv = 'n';
               ered_szin;
               menu;

          end;

{proc sz˚rÇs vÇge}


{--------------------------}
procedure help;

var szoveg: text;
    s: string;


          begin
               clrscr;
               assign(szoveg, 'help.txt');
               reset(szoveg);

               while not eof(szoveg) do
                   begin
                        read(szoveg, s);
                        writeln(s);
                        readln;
                   end;
               close(szoveg);
               menu;
          end;

{help vÇge}


{---------------------------}
{Fä PROGRAM}
begin

     TextBackground(blue);
     TextColor(white);
     clrscr;
     eredetiszin:= textattr;
     assign(filmek,'film.dat');
     {$i-}
     reset(filmek);
     {$i+}
     if ioresult = 0 then
        Seek(filmek, filesize(filmek))
     else rewrite(filmek);

     menu;

     repeat
           case szam of
                1: hozzaad;
                2: modosit;
                3: listazas;
                4: torol;
                5: szures;
                6: begin   {help}
                        figyelem;
                        gotoxy(8,2);
                        write('MÇg nincs kÇsz.');
                        readln;
                        ered_szin;
                        menu;
                   end;

                7: kilep;
                else
                    begin

                         window(33,8,50,11);
                         textbackground(red);
                         textcolor(white);
                         clrscr;
                         writeln(' Ne sz¢rakozz!!!!');
                         writeln('   (1-tãl 6-ig)');
                         writeln(' <ENTER>');
                         readln;
                         textattr:= eredetiszin;
                         window(1,1,80,25);
                         clrscr;
                         menu;
                    end;
           end;
     until (i_or_n) = 'i';

end.
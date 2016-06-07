;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname simulador-cometas) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Projeto: Fundamentos de Algoritmos
;; Período: 2016-1
;; Tarefa: Laboratório 5
;;
;; Responsável: Luiz Gustavo Frozi de Castro e Souza / 96957
;;
;; Changelog: 
;;     * 2016-06-07
;;         - Definição de Estruturas
;;         - Funções para manipulação

(define-struct posn3d (x y z))
;; Representa a uma posição no espaço tridimensional
;; Um elemento posn3d do conjunto Posn3d é uma estrutura do tipo:
;; (make-posn3d x y z)
;; onde:
;; x (número): Posição no eixo x
;; y (número): Posição no eixo y
;; z (número): Posição no eixo z
;; Exemplos
(define pos1 (make-posn3d 1 0 0))
(define pos2 (make-posn3d 2 5 10))
(define pos3 (make-posn3d 0 3 2))
(define pos4 (make-posn3d 2 0 0))
(define pos5 (make-posn3d 4 10 20))
(define pos6 (make-posn3d 0 6 4))
(define v1 (make-posn3d 100 100 100))
(define v2 (make-posn3d 50 50 50))
(define v3 (make-posn3d 10 10 10))


(define-struct cometa (tamanho material velocidade posicao))
;; Representa um cometa no espaço
;; Um elemento cometa do conjunto Cometa é uma estrutura do tipo:
;; (make-cometa t m v p)
;; onde:
;; t (número): Tamanho do cometa, massa em g
;; m (string): Material do cometa
;; v (posn3d): Velocidade do cometa em m/s, em cada um dos eixos de coordenadas
;; p (posn3d): Posição do centro de massa do cometa no espaço tridimensional
;; Exemplos
(define c1 (make-cometa 1000 "Ferro" v1 pos1))
(define c2 (make-cometa 5000 "Quartzo" v2 pos2))
(define c3 (make-cometa 10000 "Gelo" v3 pos3))

(define-struct planeta (campo-gravitacional posicao))
;; Representa um planeta no espaço
;; Um elemento planeta do conjunto Planeta é uma estrutura do tipo:
;; (make-planeta cg p)
;; onde:
;; cg (número): Força do Campo Gravitacional do planeta, em N
;; p (posn3d): Posição do centro de massa do planeta no espaço tridimensional
;; Exemplos
(define p1 (make-planeta 2000 pos1))
(define p2 (make-planeta 10000 pos2))
(define p3 (make-planeta 20000 pos3))

;; lista-de-planetas
;; Uma lista-de-planetas é uma lista definida como.
;; 1. Lista Vazia, ou empty
;; 2. ou (cons p ldp), onde
;;     p (planeta): É um elemento do tipo Quarto
;;     ldp (lista-de-planetas): Lista de planetas
;;
;; Exemplo:

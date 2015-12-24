(*
 * Copyright (C) 2015 David Scott <dave.scott@unikernel.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

module type COMPARABLE = sig
  type t

  val compare: t -> t -> int
end

module type SERIALISABLE = sig
  type t

  type 'a error = ('a, [ `Msg of string]) Result.result

  val size: int

  val marshal: t -> Cstruct.t -> Cstruct.t error
  val unmarshal: Cstruct.t -> (t * Cstruct.t) error
end

(** Data stored within the B-tree nodes *)
module type ELEMENT = sig
  type t

  include COMPARABLE with type t := t
  include SERIALISABLE with type t := t
end

(** A space of blocks in which the b-tree nodes are stored *)
module type HEAP = sig
  type t
  type 'a io

  val block_size: t -> int io

  type block = int64

  val allocate: unit -> block io
end

(** A b-tree *)
module type TREE = sig
  type t
  type 'a io
  type element

  val insert: t -> element -> t io
  val delete: t -> element -> t io
end
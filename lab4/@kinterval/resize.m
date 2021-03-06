## -*- texinfo -*-
## @documentencoding UTF-8
## @defmethod {@@kinterval} resize (@var{X}, @var{M})
## @defmethodx {@@kinterval} resize (@var{X}, @var{M}, @var{N}, ...)
## @defmethodx {@@kinterval} resize (@var{X}, [@var{M} @var{N}, ...])
##
## Resize interval array @var{X} cutting off elements as necessary.
##
## In the result, element with certain indices is equal to the corresponding
## element of @var{X} if the indices are within the bounds of @var{X};
## otherwise, the element is set to zero.
##
## If only @var{M} is supplied, and it is a scalar, the dimension of the result
## is @var{M}-by-@var{M}.  If @var{M}, @var{N}, ... are all scalars, then the
## dimensions of the result are @var{M}-by-@var{N}-by-....  If given a vector as
## input, then the dimensions of the result are given by the elements of that
## vector.
##
## An object can be resized to more dimensions than it has; in such
## case the missing dimensions are assumed to be 1.  Resizing an
## object to fewer dimensions is not possible.
##
## @example
## @group
## resize (kinterval (magic (3)), 4, 2)
##   @result{} ans = 4×2 interval matrix
##      [8]   [1]
##      [3]   [5]
##      [4]   [9]
##      [0]   [0]
## @end group
## @end example
## @seealso{@@kinterval/reshape, @@kinterval/cat, @@kinterval/postpad, @@kinterval/prepad}
## @end defmethod

function x = resize (x, varargin)

  if (not (isa (x, "kinterval")))
    print_usage ();
    return
  endif

  x.inf = resize (x.inf, varargin{:});
  x.sup = resize (x.sup, varargin{:});

  #x.inf(x.inf == 0) = -0;

endfunction

%!assert (resize (kinterval (magic (3)), 4, 2) == kinterval ([8, 1; 3, 5; 4, 9; 0, 0]));
%!assert (resize (kinterval (ones (2, 2, 2)), 4, 1, 2) == kinterval (resize (ones (2, 2, 2), 4, 1, 2)))

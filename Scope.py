from pycparser import c_ast
from compile import reserve_label

class Scope(object):
    def __init__(self, prev_scope, kind, is_loop, break_prefix=None):
        self.prev_scope = prev_scope
        self.kind = kind
        self.is_loop = is_loop
        self.break_prefix = break_prefix
        self.break_prefix_used = False
        if is_loop:
            assert break_prefix is not None
        if self.prev_scope is not None:
            self.variables = dict(self.prev_scope.variables)
        else:
            self.variables = {}
        self.frame_size = 0

    def define_variable(self, name, var_type, location=None):
        if name in self.variables:
            raise Exception("Duplicate variable name %s" % name)
        if location is None:
            location = self._pick_frame_location(var_type)
        self.variables[name] = location
        self._update_frame_size()

    def _pick_frame_location(self, var_type):
        # Unless the new variable is an array, assume that
        # it has size 1.
        sizeof = 1
        if type(var_type) == c_ast.ArrayDecl:
            sizeof = parse_int_literal(var_type.dim.value)
        lowest_used_location = min(self.variables.values(), default=0)
        new_loc = lowest_used_location - sizeof
        return new_loc

    def get_fp_rel_location(self, name):
        if name not in self.variables:
            raise Exception("Unknown var %s, scoped variables are %s" % \
                (name, self.variables))
        return self.variables[name]

    def _propagate_frame_size(self, new_frame_size):
        # if the new frame size is not bigger, don't bother
        if new_frame_size > self.frame_size:
            self.frame_size = new_frame_size
            # If this is not a top-level scope, tell the outer scope
            # how big the new frame size is
            if self.prev_scope is not None:
                self.prev_scope._propagate_frame_size(new_frame_size)

    def _update_frame_size(self):
        new_frame_size = -min(self.variables.values(), default=0)
        self._propagate_frame_size(new_frame_size)

    def get_frame_size(self):
        return self.frame_size

    def get_break_label(self):
        assert self.is_loop
        assert self.break_prefix is not None
        if not self.break_prefix_used:
            self.break_label = reserve_label(self.break_prefix)
            self.break_prefix_used = True
        return self.break_label

    def __str__(self):
        prev_scope_list = []
        current_scope = self.prev_scope
        while current_scope is not None:
            prev_scope_list.append(current_scope.kind)
            current_scope = current_scope.prev_scope
        return "Scope(prev=%s, kind=%s)" % (prev_scope_list, self.kind)

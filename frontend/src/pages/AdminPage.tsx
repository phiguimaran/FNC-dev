import AdminPanelSettingsIcon from "@mui/icons-material/AdminPanelSettings";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import InventoryIcon from "@mui/icons-material/Inventory2";
import LibraryAddIcon from "@mui/icons-material/LibraryAdd";
import PeopleIcon from "@mui/icons-material/People";
import RestaurantMenuIcon from "@mui/icons-material/RestaurantMenu";
import StoreIcon from "@mui/icons-material/Store";
import {
  Alert,
  Box,
  Button,
  Card,
  CardContent,
  CardHeader,
  Chip,
  Divider,
  Grid,
  IconButton,
  MenuItem,
  FormControlLabel,
  Switch,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  Stack,
  Tab,
  Tabs,
  TextField,
  Tooltip,
  Typography,
} from "@mui/material";
import { ChangeEvent, FormEvent, useEffect, useMemo, useState } from "react";

import {
  createDeposit,
  createRecipe,
  createSku,
  createUser,
  createMermaCause,
  createMermaType,
  createClient,
  createClientRepresentative,
  deleteDeposit,
  deleteMermaCause,
  deleteMermaType,
  deleteClient,
  deleteClientRepresentative,
  deleteRecipe,
  deleteSku,
  deleteUser,
  Deposit,
  Client,
  ClientRepresentative,
  fetchDeposits,
  fetchRecipes,
  fetchRoles,
  fetchMermaCauses,
  fetchMermaTypes,
  fetchClients,
  fetchClientRepresentatives,
  fetchSkuTypes,
  fetchStockMovementTypes,
  fetchSkus,
  fetchUnits,
  fetchUsers,
  Recipe,
  SKUFamily,
  SKU,
  MermaCause,
  MermaStage,
  MermaType,
  SKUType,
  StockMovementType,
  UnitOfMeasure,
  UnitOption,
  createSkuType,
  updateSkuType,
  deleteSkuType,
  createStockMovementType,
  updateStockMovementType,
  deleteStockMovementType,
  updateDeposit,
  updateMermaCause,
  updateMermaType,
  updateClient,
  updateClientRepresentative,
  updateRecipe,
  updateSku,
  updateUser,
  Role,
  User,
} from "../lib/api";

const PRODUCTION_TYPE_CODES = ["PT", "SEMI"];
const MERMA_STAGE_OPTIONS: { value: MermaStage; label: string }[] = [
  { value: "production", label: "Producción" },
  { value: "empaque", label: "Empaque" },
  { value: "stock", label: "Stock/Depósito" },
  { value: "transito_post_remito", label: "Tránsito post-remito" },
  { value: "administrativa", label: "Administrativa" },
];
const mermaStageLabel = (stage: MermaStage) => MERMA_STAGE_OPTIONS.find((s) => s.value === stage)?.label ?? stage;
const CLIENT_TYPE_OPTIONS = [
  { value: "empresa", label: "Empresa" },
  { value: "particular", label: "Particular" },
];
const PERSON_TYPE_OPTIONS = [
  { value: "fisica", label: "Persona física" },
  { value: "juridica", label: "Persona jurídica" },
];
const DOCUMENT_TYPE_OPTIONS = [
  { value: "DNI", label: "DNI" },
  { value: "Pasaporte", label: "Pasaporte" },
];

type RecipeFormItem = { component_id: string; quantity: string };

type TabKey = "productos" | "recetas" | "depositos" | "usuarios" | "clientes" | "catalogos";

export function AdminPage() {
  const [tab, setTab] = useState<TabKey>("productos");
  const [skus, setSkus] = useState<SKU[]>([]);
  const [skuTypes, setSkuTypes] = useState<SKUType[]>([]);
  const [movementTypes, setMovementTypes] = useState<StockMovementType[]>([]);
  const [mermaTypes, setMermaTypes] = useState<MermaType[]>([]);
  const [mermaCauses, setMermaCauses] = useState<MermaCause[]>([]);
  const [deposits, setDeposits] = useState<Deposit[]>([]);
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [roles, setRoles] = useState<Role[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [clientRepresentatives, setClientRepresentatives] = useState<ClientRepresentative[]>([]);
  const [units, setUnits] = useState<UnitOption[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [skuSearch, setSkuSearch] = useState("");
  const [recipeSearch, setRecipeSearch] = useState("");
  const [depositSearch, setDepositSearch] = useState("");
  const [userSearch, setUserSearch] = useState("");
  const [showInactiveSkus, setShowInactiveSkus] = useState(false);
  const [clientSearch, setClientSearch] = useState("");
  const [showInactiveClients, setShowInactiveClients] = useState(false);
  const [selectedClientId, setSelectedClientId] = useState<number | "">("");

  const [skuForm, setSkuForm] = useState<{ id?: number; code: string; name: string; sku_type_id: number | ""; unit: UnitOfMeasure; units_per_kg?: number | ""; notes: string; family: SKUFamily | ""; is_active: boolean }>(
    {
      code: "",
      name: "",
      sku_type_id: "",
      unit: "unit",
      units_per_kg: "",
      notes: "",
      family: "",
      is_active: true,
    }
  );
  const [depositForm, setDepositForm] = useState<{ id?: number; name: string; location: string; controls_lot: boolean; is_store: boolean }>(
    {
      name: "",
      location: "",
      controls_lot: true,
      is_store: false,
    }
  );
  const [recipeForm, setRecipeForm] = useState<{ id?: number; product_id: string; name: string; items: RecipeFormItem[] }>(
    {
      product_id: "",
      name: "",
      items: [{ component_id: "", quantity: "" }],
    }
  );
  const [userForm, setUserForm] = useState<{ id?: number; email: string; full_name: string; password: string; role_id: string; is_active: boolean }>(
    {
      email: "",
      full_name: "",
      password: "",
      role_id: "",
      is_active: true,
    }
  );
  const [clientForm, setClientForm] = useState<{ id?: number; name: string; client_type: string; is_active: boolean }>(
    {
      name: "",
      client_type: "empresa",
      is_active: true,
    }
  );
  const [representativeForm, setRepresentativeForm] = useState<{
    id?: number;
    full_name: string;
    person_type: string;
    document_type: string;
    document_number: string;
    email: string;
    phone: string;
    address: string;
    notes: string;
    is_active: boolean;
  }>(
    {
      full_name: "",
      person_type: "fisica",
      document_type: "DNI",
      document_number: "",
      email: "",
      phone: "",
      address: "",
      notes: "",
      is_active: true,
    }
  );
  const [skuTypeForm, setSkuTypeForm] = useState<{ id?: number; code: string; label: string; is_active: boolean }>({
    code: "",
    label: "",
    is_active: true,
  });
  const [movementTypeForm, setMovementTypeForm] = useState<{ id?: number; code: string; label: string; is_active: boolean }>({
    code: "",
    label: "",
    is_active: true,
  });
  const [mermaTypeForm, setMermaTypeForm] = useState<{ id?: number; stage: MermaStage; code: string; label: string; is_active: boolean }>({
    stage: "production",
    code: "",
    label: "",
    is_active: true,
  });
  const [mermaCauseForm, setMermaCauseForm] = useState<{ id?: number; stage: MermaStage; code: string; label: string; is_active: boolean }>({
    stage: "production",
    code: "",
    label: "",
    is_active: true,
  });

  useEffect(() => {
    void loadData();
  }, []);

  useEffect(() => {
    if (!selectedClientId) {
      setClientRepresentatives([]);
      return;
    }
    void loadClientRepresentatives(Number(selectedClientId));
  }, [selectedClientId]);

  const sortedSkus = useMemo(() => [...skus].sort((a, b) => a.name.localeCompare(b.name)), [skus]);
  const sortedDeposits = useMemo(() => [...deposits].sort((a, b) => a.name.localeCompare(b.name)), [deposits]);
  const sortedClients = useMemo(() => [...clients].sort((a, b) => a.name.localeCompare(b.name)), [clients]);
  const skuMap = useMemo(() => new Map(skus.map((sku) => [sku.id, sku])), [skus]);
  const skuTypeMap = useMemo(() => new Map(skuTypes.map((type) => [type.id, type])), [skuTypes]);
  const sortedSkuTypes = useMemo(() => [...skuTypes].sort((a, b) => a.code.localeCompare(b.code)), [skuTypes]);
  const sortedMovementTypes = useMemo(() => [...movementTypes].sort((a, b) => a.code.localeCompare(b.code)), [movementTypes]);
  const sortedMermaTypes = useMemo(
    () => [...mermaTypes].sort((a, b) => a.stage.localeCompare(b.stage) || a.code.localeCompare(b.code)),
    [mermaTypes]
  );
  const sortedMermaCauses = useMemo(
    () => [...mermaCauses].sort((a, b) => a.stage.localeCompare(b.stage) || a.code.localeCompare(b.code)),
    [mermaCauses]
  );

  const matchesSearch = (text: string, search: string) => text.toLowerCase().includes(search.trim().toLowerCase());

  const filteredSkus = useMemo(
    () =>
      sortedSkus.filter(
        (sku) => (showInactiveSkus || sku.is_active) && (!skuSearch || matchesSearch(`${sku.name} ${sku.code}`, skuSearch))
      ),
    [sortedSkus, showInactiveSkus, skuSearch]
  );
  const recipeComponents = useMemo(
    () => sortedSkus.filter((sku) => PRODUCTION_TYPE_CODES.includes(sku.sku_type_code) && (showInactiveSkus || sku.is_active)),
    [sortedSkus, showInactiveSkus]
  );
  const filteredRecipes = useMemo(
    () =>
      recipes.filter((recipe) => {
        if (!recipeSearch) return true;
        const product = skuMap.get(recipe.product_id);
        return matchesSearch(`${recipe.name} ${product?.name ?? ""}`, recipeSearch);
      }),
    [recipes, recipeSearch, skuMap]
  );
  const filteredDeposits = useMemo(
    () =>
      sortedDeposits.filter((deposit) =>
        depositSearch ? matchesSearch(`${deposit.name} ${deposit.location ?? ""}`, depositSearch) : true
      ),
    [sortedDeposits, depositSearch]
  );
  const filteredUsers = useMemo(
    () =>
      users.filter((user) =>
        userSearch ? matchesSearch(`${user.full_name} ${user.email} ${user.role_name ?? ""}`, userSearch) : true
      ),
    [users, userSearch]
  );
  const filteredClients = useMemo(
    () =>
      sortedClients.filter(
        (client) =>
          (showInactiveClients || client.is_active) &&
          (!clientSearch || matchesSearch(`${client.name} ${client.client_type}`, clientSearch))
      ),
    [sortedClients, showInactiveClients, clientSearch]
  );
  const selectedClient = useMemo(
    () => clients.find((client) => client.id === Number(selectedClientId)),
    [clients, selectedClientId]
  );
  const selectedSkuType = skuForm.sku_type_id ? skuTypeMap.get(Number(skuForm.sku_type_id)) : undefined;
  const isSemiSku = selectedSkuType?.code === "SEMI";

  const loadData = async () => {
    try {
      const [
        skuList,
        depositList,
        recipeList,
        roleList,
        userList,
        unitList,
        skuTypeList,
        movementTypeList,
        mermaTypeList,
        mermaCauseList,
        clientList,
      ] = await Promise.all([
        fetchSkus({ include_inactive: true }),
        fetchDeposits(),
        fetchRecipes(),
        fetchRoles(),
        fetchUsers(),
        fetchUnits(),
        fetchSkuTypes({ include_inactive: true }),
        fetchStockMovementTypes({ include_inactive: true }),
        fetchMermaTypes({ include_inactive: true }),
        fetchMermaCauses({ include_inactive: true }),
        fetchClients({ include_inactive: true }),
      ]);
      setSkus(skuList);
      setDeposits(depositList);
      setRecipes(recipeList);
      setRoles(roleList);
      setUsers(userList);
      setUnits(unitList);
      setSkuTypes(skuTypeList);
      setMovementTypes(movementTypeList);
      setMermaTypes(mermaTypeList);
      setMermaCauses(mermaCauseList);
      setClients(clientList);

      const defaultSkuType = skuTypeList.find((t) => t.code === "MP" && t.is_active) ?? skuTypeList.find((t) => t.is_active);
      if (defaultSkuType && !skuForm.sku_type_id) {
        setSkuForm((prev) => ({ ...prev, sku_type_id: defaultSkuType.id }));
      }
      if (!selectedClientId && clientList.length) {
        const activeClient = clientList.find((client) => client.is_active) ?? clientList[0];
        setSelectedClientId(activeClient?.id ?? "");
      }
      setError(null);
    } catch (err) {
      console.error(err);
      setError("No pudimos cargar los catálogos. ¿Está levantado el backend?");
    }
  };

  const loadClientRepresentatives = async (clientId: number) => {
    try {
      const reps = await fetchClientRepresentatives(clientId, { include_inactive: true });
      setClientRepresentatives(reps);
      setError(null);
    } catch (err) {
      console.error(err);
      setError("No pudimos cargar los apoderados");
    }
  };

  const resetMessages = () => {
    setSuccess(null);
    setError(null);
  };

  const handleSkuSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      if (!skuForm.sku_type_id) {
        setError("Selecciona un tipo de SKU");
        return;
      }
      const selectedType = skuTypes.find((type) => type.id === skuForm.sku_type_id);
      if (!selectedType) {
        setError("Tipo de SKU inválido");
        return;
      }
      const isSemi = selectedType.code === "SEMI";
      const unitsPerKgValue = isSemi ? Number(skuForm.units_per_kg || 1) : undefined;
      if (isSemi && (!unitsPerKgValue || unitsPerKgValue <= 0)) {
        setError("Configura las unidades por kg para SEMI");
        return;
      }
      const { id, units_per_kg, ...rest } = skuForm;
      const payload = {
        ...rest,
        unit: isSemi ? "kg" : skuForm.unit,
        units_per_kg: unitsPerKgValue,
        sku_type_id: selectedType.id,
        notes: skuForm.notes || null,
        family: selectedType.code === "CON" ? (skuForm.family || null) : null,
        is_active: skuForm.is_active,
      };
      if (skuForm.id) {
        await updateSku(skuForm.id, payload);
        setSuccess("Producto actualizado");
      } else {
        await createSku(payload);
        setSuccess("Producto creado");
      }
      const defaultSkuType = skuTypes.find((t) => t.code === "MP" && t.is_active) ?? skuTypes.find((t) => t.is_active);
      setSkuForm({
        code: "",
        name: "",
        sku_type_id: defaultSkuType?.id ?? "",
        unit: "unit",
        units_per_kg: "",
        notes: "",
        family: "",
        is_active: true,
      });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el producto. Revisa duplicados o datos faltantes.");
    }
  };

  const handleDepositSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      const { id, ...rest } = depositForm;
      const payload = { ...rest, location: depositForm.location || null };
      if (depositForm.id) {
        await updateDeposit(depositForm.id, payload);
        setSuccess("Depósito actualizado");
      } else {
        await createDeposit(payload);
        setSuccess("Depósito creado");
      }
      setDepositForm({ name: "", location: "", controls_lot: true, is_store: false });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el depósito. ¿Nombre duplicado?");
    }
  };

  const handleRecipeSubmit = async (event: FormEvent) => {
    event.preventDefault();
    if (!recipeForm.product_id || recipeForm.items.some((i) => !i.component_id || !i.quantity)) {
      setError("Completa el producto y los componentes");
      return;
    }
    try {
      const payload = {
        product_id: Number(recipeForm.product_id),
        name: recipeForm.name || skuMap.get(Number(recipeForm.product_id))?.name || "Receta",
        items: recipeForm.items.map((item) => ({ component_id: Number(item.component_id), quantity: Number(item.quantity) })),
      };
      if (recipeForm.id) {
        await updateRecipe(recipeForm.id, payload);
        setSuccess("Receta actualizada");
      } else {
        await createRecipe(payload);
        setSuccess("Receta creada");
      }
      setRecipeForm({ id: undefined, product_id: "", name: "", items: [{ component_id: "", quantity: "" }] });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar la receta. Verifica los datos");
    }
  };

  const handleUserSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      const payload = {
        email: userForm.email,
        full_name: userForm.full_name,
        password: userForm.password,
        role_id: userForm.role_id ? Number(userForm.role_id) : undefined,
        is_active: userForm.is_active,
      };
      if (userForm.id) {
        await updateUser(userForm.id, { ...payload, password: userForm.password || undefined });
        setSuccess("Usuario actualizado");
      } else {
        await createUser(payload);
        setSuccess("Usuario creado");
      }
      setUserForm({ id: undefined, email: "", full_name: "", password: "", role_id: "", is_active: true });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el usuario. Revisa duplicados o datos requeridos.");
    }
  };

  const handleClientSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      if (!clientForm.name || !clientForm.client_type) {
        setError("Completa nombre y tipo de cliente");
        return;
      }
      if (clientForm.id) {
        await updateClient(clientForm.id, {
          name: clientForm.name,
          client_type: clientForm.client_type,
          is_active: clientForm.is_active,
        });
        setSuccess("Cliente actualizado");
      } else {
        await createClient({
          name: clientForm.name,
          client_type: clientForm.client_type,
          is_active: clientForm.is_active,
        });
        setSuccess("Cliente creado");
      }
      setClientForm({ id: undefined, name: "", client_type: "empresa", is_active: true });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el cliente");
    }
  };

  const handleRepresentativeSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      if (!selectedClientId) {
        setError("Selecciona un cliente");
        return;
      }
      if (!representativeForm.full_name || !representativeForm.document_number) {
        setError("Completa nombre y documento");
        return;
      }
      const payload = {
        full_name: representativeForm.full_name,
        person_type: representativeForm.person_type,
        document_type: representativeForm.document_type,
        document_number: representativeForm.document_number,
        email: representativeForm.email || null,
        phone: representativeForm.phone || null,
        address: representativeForm.address || null,
        notes: representativeForm.notes || null,
        is_active: representativeForm.is_active,
      };
      if (representativeForm.id) {
        await updateClientRepresentative(Number(selectedClientId), representativeForm.id, payload);
        setSuccess("Apoderado actualizado");
      } else {
        await createClientRepresentative(Number(selectedClientId), payload);
        setSuccess("Apoderado creado");
      }
      setRepresentativeForm({
        id: undefined,
        full_name: "",
        person_type: "fisica",
        document_type: "DNI",
        document_number: "",
        email: "",
        phone: "",
        address: "",
        notes: "",
        is_active: true,
      });
      await loadClientRepresentatives(Number(selectedClientId));
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el apoderado");
    }
  };

  const handleRecipeItemChange = (index: number, field: keyof RecipeFormItem, value: string) => {
    setRecipeForm((prev) => {
      const items = [...prev.items];
      items[index] = { ...items[index], [field]: value };
      return { ...prev, items };
    });
  };

  const addRecipeItem = () => setRecipeForm((prev) => ({ ...prev, items: [...prev.items, { component_id: "", quantity: "" }] }));
  const removeRecipeItem = (index: number) =>
    setRecipeForm((prev) => ({ ...prev, items: prev.items.filter((_, idx) => idx !== index) }));

  const startEditRecipe = (recipe: Recipe) => {
    setRecipeForm({
      id: recipe.id,
      product_id: String(recipe.product_id),
      name: recipe.name,
      items: recipe.items.map((item) => ({ component_id: String(item.component_id), quantity: String(item.quantity) })),
    });
    setTab("recetas");
  };

  const startEditSku = (sku: SKU) =>
    setSkuForm({
      id: sku.id,
      code: sku.code,
      name: sku.name,
      sku_type_id: sku.sku_type_id,
      unit: sku.unit,
      units_per_kg: sku.units_per_kg ?? "",
      notes: sku.notes ?? "",
      family: sku.family ?? "",
      is_active: sku.is_active,
    });
  const startEditDeposit = (deposit: Deposit) =>
    setDepositForm({
      id: deposit.id,
      name: deposit.name,
      location: deposit.location ?? "",
      controls_lot: deposit.controls_lot,
      is_store: deposit.is_store,
    });
  const startEditUser = (user: User) =>
    setUserForm({
      id: user.id,
      email: user.email,
      full_name: user.full_name,
      password: "",
      role_id: user.role_id ? String(user.role_id) : "",
      is_active: user.is_active,
    });
  const startEditClient = (client: Client) =>
    setClientForm({
      id: client.id,
      name: client.name,
      client_type: client.client_type,
      is_active: client.is_active,
    });
  const startEditRepresentative = (representative: ClientRepresentative) =>
    setRepresentativeForm({
      id: representative.id,
      full_name: representative.full_name,
      person_type: representative.person_type,
      document_type: representative.document_type,
      document_number: representative.document_number,
      email: representative.email ?? "",
      phone: representative.phone ?? "",
      address: representative.address ?? "",
      notes: representative.notes ?? "",
      is_active: representative.is_active,
    });

  const skuLabel = (sku: SKU) => `${sku.name} (${sku.code})`;
  const unitLabel = (unitCode?: UnitOfMeasure) => units.find((u) => u.code === unitCode)?.label || unitCode || "";

  const recipeItemUnit = (componentId: string) => {
    if (!componentId) return "";
    const component = skuMap.get(Number(componentId));
    return component ? unitLabel(component.unit) : "";
  };

  const filteredProducts = recipeComponents;

  const handleDelete = async (
    type: "sku" | "deposit" | "recipe" | "user" | "client" | "representative",
    id: number,
    parentId?: number
  ) => {
    if (!window.confirm("¿Eliminar el registro?")) return;
    try {
      if (type === "sku") await deleteSku(id);
      if (type === "deposit") await deleteDeposit(id);
      if (type === "recipe") await deleteRecipe(id);
      if (type === "user") await deleteUser(id);
      if (type === "client") await deleteClient(id);
      if (type === "representative") {
        if (!parentId) {
          setError("Selecciona un cliente antes de eliminar un apoderado");
          return;
        }
        await deleteClientRepresentative(parentId, id);
      }
      setSuccess("Registro eliminado");
      await loadData();
      if (type === "representative" && parentId) {
        await loadClientRepresentatives(parentId);
      }
    } catch (err) {
      console.error(err);
      setError("No pudimos eliminar el registro");
    }
  };

  const handleSkuTypeSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      if (!skuTypeForm.code || !skuTypeForm.label) {
        setError("Completa código y etiqueta");
        return;
      }
      if (skuTypeForm.id) {
        await updateSkuType(skuTypeForm.id, { label: skuTypeForm.label, is_active: skuTypeForm.is_active });
        setSuccess("Tipo de SKU actualizado");
      } else {
        await createSkuType({
          code: skuTypeForm.code.toUpperCase(),
          label: skuTypeForm.label,
          is_active: skuTypeForm.is_active,
        });
        setSuccess("Tipo de SKU creado");
      }
      setSkuTypeForm({ id: undefined, code: "", label: "", is_active: true });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el tipo de SKU. ¿Código duplicado?");
    }
  };

  const handleMovementTypeSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      if (!movementTypeForm.code || !movementTypeForm.label) {
        setError("Completa código y etiqueta");
        return;
      }
      if (movementTypeForm.id) {
        await updateStockMovementType(movementTypeForm.id, {
          label: movementTypeForm.label,
          is_active: movementTypeForm.is_active,
        });
        setSuccess("Tipo de movimiento actualizado");
      } else {
        await createStockMovementType({
          code: movementTypeForm.code.toUpperCase(),
          label: movementTypeForm.label,
          is_active: movementTypeForm.is_active,
        });
        setSuccess("Tipo de movimiento creado");
      }
      setMovementTypeForm({ id: undefined, code: "", label: "", is_active: true });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el tipo de movimiento. ¿Código duplicado?");
    }
  };

  const handleMermaTypeSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      if (!mermaTypeForm.code || !mermaTypeForm.label) {
        setError("Completa código, etapa y etiqueta");
        return;
      }
      if (mermaTypeForm.id) {
        await updateMermaType(mermaTypeForm.id, {
          stage: mermaTypeForm.stage,
          label: mermaTypeForm.label,
          is_active: mermaTypeForm.is_active,
        });
        setSuccess("Tipo de merma actualizado");
      } else {
        await createMermaType({
          stage: mermaTypeForm.stage,
          code: mermaTypeForm.code,
          label: mermaTypeForm.label,
          is_active: mermaTypeForm.is_active,
        });
        setSuccess("Tipo de merma creado");
      }
      setMermaTypeForm({ id: undefined, stage: "production", code: "", label: "", is_active: true });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar el tipo de merma. ¿Código duplicado?");
    }
  };

  const handleMermaCauseSubmit = async (event: FormEvent) => {
    event.preventDefault();
    try {
      if (!mermaCauseForm.code || !mermaCauseForm.label) {
        setError("Completa código, etapa y etiqueta");
        return;
      }
      if (mermaCauseForm.id) {
        await updateMermaCause(mermaCauseForm.id, {
          stage: mermaCauseForm.stage,
          label: mermaCauseForm.label,
          is_active: mermaCauseForm.is_active,
        });
        setSuccess("Causa de merma actualizada");
      } else {
        await createMermaCause({
          stage: mermaCauseForm.stage,
          code: mermaCauseForm.code,
          label: mermaCauseForm.label,
          is_active: mermaCauseForm.is_active,
        });
        setSuccess("Causa de merma creada");
      }
      setMermaCauseForm({ id: undefined, stage: "production", code: "", label: "", is_active: true });
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos guardar la causa de merma. ¿Código duplicado?");
    }
  };

  const handleSkuTypeDelete = async (id: number) => {
    if (!window.confirm("¿Eliminar/desactivar el tipo de SKU?")) return;
    try {
      await deleteSkuType(id);
      setSuccess("Tipo de SKU actualizado");
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos eliminar el tipo de SKU");
    }
  };

  const handleMovementTypeDelete = async (id: number) => {
    if (!window.confirm("¿Eliminar/desactivar el tipo de movimiento?")) return;
    try {
      await deleteStockMovementType(id);
      setSuccess("Tipo de movimiento actualizado");
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos eliminar el tipo de movimiento");
    }
  };

  const handleMermaTypeDelete = async (id: number) => {
    if (!window.confirm("¿Desactivar el tipo de merma?")) return;
    try {
      await deleteMermaType(id);
      setSuccess("Tipo de merma desactivado");
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos desactivar el tipo de merma");
    }
  };

  const handleMermaCauseDelete = async (id: number) => {
    if (!window.confirm("¿Desactivar la causa de merma?")) return;
    try {
      await deleteMermaCause(id);
      setSuccess("Causa de merma desactivada");
      await loadData();
    } catch (err) {
      console.error(err);
      setError("No pudimos desactivar la causa de merma");
    }
  };

  const renderProductos = () => (
    <Grid container spacing={2} alignItems="stretch">
      <Grid item xs={12} md={4}>
        <Card>
          <CardHeader title="Producto" subheader={skuForm.id ? "Editar" : "Alta"} avatar={<InventoryIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleSkuSubmit}>
              <TextField label="Código" required value={skuForm.code} onChange={(e) => setSkuForm((prev) => ({ ...prev, code: e.target.value }))} />
              <TextField label="Nombre" required value={skuForm.name} onChange={(e) => setSkuForm((prev) => ({ ...prev, name: e.target.value }))} />
              <TextField
                select
                label="Tipo"
                required
                value={skuForm.sku_type_id}
                onChange={(e) => {
                  const typeId = Number(e.target.value);
                  const type = skuTypeMap.get(typeId);
                  setSkuForm((prev) => ({
                    ...prev,
                    sku_type_id: typeId,
                    unit: type?.code === "SEMI" ? "kg" : prev.unit,
                    units_per_kg: type?.code === "SEMI" ? prev.units_per_kg || 1 : "",
                    family: type?.code === "CON" ? prev.family : "",
                  }));
                }}
                helperText="Tipos administrables"
              >
                {skuTypes.map((type) => (
                  <MenuItem key={type.id} value={type.id} disabled={!type.is_active}>
                    {type.code} — {type.label}
                    {!type.is_active ? " (inactivo)" : ""}
                  </MenuItem>
                ))}
              </TextField>
              {selectedSkuType?.code === "CON" && (
                <TextField
                  select
                  label="Familia (consumibles)"
                  value={skuForm.family}
                  onChange={(e) => setSkuForm((prev) => ({ ...prev, family: e.target.value as SKUFamily }))}
                  required
                >
                  <MenuItem value="consumible">Consumible</MenuItem>
                  <MenuItem value="papeleria">Papelería</MenuItem>
                  <MenuItem value="limpieza">Limpieza</MenuItem>
                </TextField>
              )}
              <TextField
                select
                label="Unidad"
                value={skuForm.unit}
                onChange={(e) => setSkuForm((prev) => ({ ...prev, unit: e.target.value as UnitOfMeasure }))}
                helperText={isSemiSku ? "Los SEMI operan en kg como unidad base" : undefined}
                disabled={isSemiSku}
              >
                {units.map((unit) => (
                  <MenuItem key={unit.code} value={unit.code}>
                    {unit.label}
                  </MenuItem>
                ))}
              </TextField>
              {isSemiSku && (
                <TextField
                  label="Unidades por kg (SEMI)"
                  type="number"
                  inputProps={{ min: "0.0001", step: "0.01" }}
                  value={skuForm.units_per_kg}
                  onChange={(e) => setSkuForm((prev) => ({ ...prev, units_per_kg: Number(e.target.value) }))}
                  helperText="Equivalencia de la unidad operativa vs kg base"
                  required
                />
              )}
              <TextField
                label="Notas"
                value={skuForm.notes}
                onChange={(e) => setSkuForm((prev) => ({ ...prev, notes: e.target.value }))}
                multiline
                minRows={2}
              />
              <FormControlLabel
                control={<Switch checked={skuForm.is_active} onChange={(e) => setSkuForm((prev) => ({ ...prev, is_active: e.target.checked }))} />}
                label="Activo (visible por defecto en los combos)"
              />
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {skuForm.id ? "Actualizar" : "Crear"}
                </Button>
                {skuForm.id && (
                  <Button
                    onClick={() => {
                      const defaultSkuType = skuTypes.find((t) => t.code === "MP" && t.is_active) ?? skuTypes.find((t) => t.is_active);
                      setSkuForm({
                        id: undefined,
                        code: "",
                        name: "",
                        sku_type_id: defaultSkuType?.id ?? "",
                        unit: "unit",
                        units_per_kg: "",
                        notes: "",
                        family: "",
                        is_active: true,
                      });
                    }}
                  >
                    Cancelar
                  </Button>
                )}
              </Stack>
            </Stack>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={8}>
        <Card>
          <CardHeader
            title="Productos"
            subheader="Listado compacto"
            action={<Chip label={`${filteredSkus.length} de ${skus.length}`} />}
          />
          <Divider />
          <CardContent>
            <Stack direction={{ xs: "column", md: "row" }} spacing={2} justifyContent="space-between" alignItems={{ md: "center" }} sx={{ mb: 2 }}>
              <TextField
                label="Buscar por nombre o código"
                value={skuSearch}
                onChange={(e) => setSkuSearch(e.target.value)}
                size="small"
                sx={{ maxWidth: 320 }}
              />
              <FormControlLabel
                control={<Switch checked={showInactiveSkus} onChange={(e) => setShowInactiveSkus(e.target.checked)} />}
                label="Mostrar inactivos"
              />
            </Stack>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Código</TableCell>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Tipo</TableCell>
                  <TableCell>Familia</TableCell>
                  <TableCell>Unidad</TableCell>
                  <TableCell>Conv. SEMI</TableCell>
                  <TableCell>Estado</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {filteredSkus.map((sku) => (
                  <TableRow key={sku.id} hover>
                    <TableCell>{sku.code}</TableCell>
                    <TableCell>{sku.name}</TableCell>
                    <TableCell>{`${sku.sku_type_code} — ${sku.sku_type_label}`}</TableCell>
                    <TableCell>{sku.sku_type_code === "CON" ? sku.family || "—" : "—"}</TableCell>
                    <TableCell>{unitLabel(sku.unit)}</TableCell>
                    <TableCell>
                      {sku.sku_type_code === "SEMI" ? `${sku.units_per_kg ?? 1} un = 1 kg` : "—"}
                    </TableCell>
                    <TableCell>{sku.is_active ? "Activo" : "Inactivo"}</TableCell>
                    <TableCell align="right">
                      <Tooltip title="Editar">
                        <IconButton size="small" onClick={() => startEditSku(sku)}>
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Eliminar">
                        <IconButton size="small" color="error" onClick={() => handleDelete("sku", sku.id)}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  const renderCatalogos = () => (
    <Grid container spacing={2}>
      <Grid item xs={12} md={6}>
        <Card>
          <CardHeader title="Tipos de SKU" subheader="Catálogo administrable" avatar={<LibraryAddIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleSkuTypeSubmit}>
              <TextField
                label="Código"
                value={skuTypeForm.code}
                onChange={(e) => setSkuTypeForm((prev) => ({ ...prev, code: e.target.value.toUpperCase() }))}
                inputProps={{ style: { textTransform: "uppercase" } }}
                required
                disabled={!!skuTypeForm.id}
              />
              <TextField
                label="Nombre visible"
                value={skuTypeForm.label}
                onChange={(e) => setSkuTypeForm((prev) => ({ ...prev, label: e.target.value }))}
                required
              />
              <FormControlLabel
                control={
                  <Switch
                    checked={skuTypeForm.is_active}
                    onChange={(e) => setSkuTypeForm((prev) => ({ ...prev, is_active: e.target.checked }))}
                  />
                }
                label="Activo"
              />
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {skuTypeForm.id ? "Actualizar" : "Crear"}
                </Button>
                {skuTypeForm.id && (
                  <Button onClick={() => setSkuTypeForm({ id: undefined, code: "", label: "", is_active: true })}>Cancelar</Button>
                )}
              </Stack>
            </Stack>
            <Divider sx={{ my: 2 }} />
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Código</TableCell>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Estado</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {sortedSkuTypes.map((type) => (
                  <TableRow key={type.id} hover>
                    <TableCell>{type.code}</TableCell>
                    <TableCell>{type.label}</TableCell>
                    <TableCell>{type.is_active ? "Activo" : "Inactivo"}</TableCell>
                    <TableCell align="right">
                      <Tooltip title="Editar">
                        <IconButton size="small" onClick={() => setSkuTypeForm({ ...type })}>
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Eliminar / desactivar">
                        <IconButton size="small" color="error" onClick={() => handleSkuTypeDelete(type.id)}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={6}>
        <Card>
          <CardHeader title="Tipos de movimiento de stock" subheader="Impacto en kardex" avatar={<LibraryAddIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleMovementTypeSubmit}>
              <TextField
                label="Código"
                value={movementTypeForm.code}
                onChange={(e) => setMovementTypeForm((prev) => ({ ...prev, code: e.target.value.toUpperCase() }))}
                inputProps={{ style: { textTransform: "uppercase" } }}
                required
                disabled={!!movementTypeForm.id}
              />
              <TextField
                label="Nombre visible"
                value={movementTypeForm.label}
                onChange={(e) => setMovementTypeForm((prev) => ({ ...prev, label: e.target.value }))}
                required
              />
              <FormControlLabel
                control={
                  <Switch
                    checked={movementTypeForm.is_active}
                    onChange={(e) => setMovementTypeForm((prev) => ({ ...prev, is_active: e.target.checked }))}
                  />
                }
                label="Activo"
              />
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {movementTypeForm.id ? "Actualizar" : "Crear"}
                </Button>
                {movementTypeForm.id && (
                  <Button onClick={() => setMovementTypeForm({ id: undefined, code: "", label: "", is_active: true })}>Cancelar</Button>
                )}
              </Stack>
            </Stack>
            <Divider sx={{ my: 2 }} />
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Código</TableCell>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Estado</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {sortedMovementTypes.map((type) => (
                  <TableRow key={type.id} hover>
                    <TableCell>{type.code}</TableCell>
                    <TableCell>{type.label}</TableCell>
                    <TableCell>{type.is_active ? "Activo" : "Inactivo"}</TableCell>
                    <TableCell align="right">
                      <Tooltip title="Editar">
                        <IconButton size="small" onClick={() => setMovementTypeForm({ ...type })}>
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Eliminar / desactivar">
                        <IconButton size="small" color="error" onClick={() => handleMovementTypeDelete(type.id)}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={6}>
        <Card>
          <CardHeader title="Tipos de merma" subheader="Catálogo por etapa" avatar={<LibraryAddIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleMermaTypeSubmit}>
              <TextField
                select
                label="Etapa"
                value={mermaTypeForm.stage}
                onChange={(e) => setMermaTypeForm((prev) => ({ ...prev, stage: e.target.value as MermaStage }))}
              >
                {MERMA_STAGE_OPTIONS.map((option) => (
                  <MenuItem key={option.value} value={option.value}>
                    {option.label}
                  </MenuItem>
                ))}
              </TextField>
              <TextField
                label="Código"
                value={mermaTypeForm.code}
                onChange={(e) => setMermaTypeForm((prev) => ({ ...prev, code: e.target.value.toUpperCase() }))}
                inputProps={{ style: { textTransform: "uppercase" } }}
                required
                disabled={!!mermaTypeForm.id}
              />
              <TextField
                label="Nombre visible"
                value={mermaTypeForm.label}
                onChange={(e) => setMermaTypeForm((prev) => ({ ...prev, label: e.target.value }))}
                required
              />
              <FormControlLabel
                control={
                  <Switch
                    checked={mermaTypeForm.is_active}
                    onChange={(e) => setMermaTypeForm((prev) => ({ ...prev, is_active: e.target.checked }))}
                  />
                }
                label="Activo"
              />
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {mermaTypeForm.id ? "Actualizar" : "Crear"}
                </Button>
                {mermaTypeForm.id && (
                  <Button onClick={() => setMermaTypeForm({ id: undefined, stage: "production", code: "", label: "", is_active: true })}>
                    Cancelar
                  </Button>
                )}
              </Stack>
            </Stack>
            <Divider sx={{ my: 2 }} />
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Etapa</TableCell>
                  <TableCell>Código</TableCell>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Estado</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {sortedMermaTypes.map((type) => (
                  <TableRow key={type.id} hover>
                    <TableCell>{mermaStageLabel(type.stage)}</TableCell>
                  <TableCell>{type.code}</TableCell>
                  <TableCell>{type.label}</TableCell>
                  <TableCell>{type.is_active ? "Activo" : "Inactivo"}</TableCell>
                  <TableCell align="right">
                      <Stack direction="row" spacing={1} alignItems="center" justifyContent="flex-end">
                        <Switch
                          checked={type.is_active}
                          onChange={async (e) => {
                            try {
                              await updateMermaType(type.id, { is_active: e.target.checked });
                              await loadData();
                            } catch (err) {
                              console.error(err);
                              setError("No pudimos actualizar el estado");
                            }
                          }}
                        />
                        <Tooltip title="Editar">
                          <IconButton size="small" onClick={() => setMermaTypeForm({ ...type })}>
                            <EditIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Desactivar">
                          <IconButton size="small" color="error" onClick={() => handleMermaTypeDelete(type.id)}>
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </Stack>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={6}>
        <Card>
          <CardHeader title="Causas de merma" subheader="Catálogo por etapa" avatar={<LibraryAddIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleMermaCauseSubmit}>
              <TextField
                select
                label="Etapa"
                value={mermaCauseForm.stage}
                onChange={(e) => setMermaCauseForm((prev) => ({ ...prev, stage: e.target.value as MermaStage }))}
              >
                {MERMA_STAGE_OPTIONS.map((option) => (
                  <MenuItem key={option.value} value={option.value}>
                    {option.label}
                  </MenuItem>
                ))}
              </TextField>
              <TextField
                label="Código"
                value={mermaCauseForm.code}
                onChange={(e) => setMermaCauseForm((prev) => ({ ...prev, code: e.target.value.toUpperCase() }))}
                inputProps={{ style: { textTransform: "uppercase" } }}
                required
                disabled={!!mermaCauseForm.id}
              />
              <TextField
                label="Nombre visible"
                value={mermaCauseForm.label}
                onChange={(e) => setMermaCauseForm((prev) => ({ ...prev, label: e.target.value }))}
                required
              />
              <FormControlLabel
                control={
                  <Switch
                    checked={mermaCauseForm.is_active}
                    onChange={(e) => setMermaCauseForm((prev) => ({ ...prev, is_active: e.target.checked }))}
                  />
                }
                label="Activo"
              />
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {mermaCauseForm.id ? "Actualizar" : "Crear"}
                </Button>
                {mermaCauseForm.id && (
                  <Button onClick={() => setMermaCauseForm({ id: undefined, stage: "production", code: "", label: "", is_active: true })}>
                    Cancelar
                  </Button>
                )}
              </Stack>
            </Stack>
            <Divider sx={{ my: 2 }} />
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Etapa</TableCell>
                  <TableCell>Código</TableCell>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Estado</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {sortedMermaCauses.map((cause) => (
                  <TableRow key={cause.id} hover>
                    <TableCell>{mermaStageLabel(cause.stage)}</TableCell>
                  <TableCell>{cause.code}</TableCell>
                  <TableCell>{cause.label}</TableCell>
                  <TableCell>{cause.is_active ? "Activo" : "Inactivo"}</TableCell>
                  <TableCell align="right">
                      <Stack direction="row" spacing={1} alignItems="center" justifyContent="flex-end">
                        <Switch
                          checked={cause.is_active}
                          onChange={async (e) => {
                            try {
                              await updateMermaCause(cause.id, { is_active: e.target.checked });
                              await loadData();
                            } catch (err) {
                              console.error(err);
                              setError("No pudimos actualizar el estado");
                            }
                          }}
                        />
                        <Tooltip title="Editar">
                          <IconButton size="small" onClick={() => setMermaCauseForm({ ...cause })}>
                            <EditIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Desactivar">
                          <IconButton size="small" color="error" onClick={() => handleMermaCauseDelete(cause.id)}>
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </Stack>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  const renderDepositos = () => (
    <Grid container spacing={2} alignItems="stretch">
      <Grid item xs={12} md={4}>
        <Card>
          <CardHeader title="Depósito" subheader={depositForm.id ? "Editar" : "Alta"} avatar={<StoreIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleDepositSubmit}>
              <TextField label="Nombre" required value={depositForm.name} onChange={(e) => setDepositForm((prev) => ({ ...prev, name: e.target.value }))} />
              <TextField label="Ubicación" value={depositForm.location} onChange={(e) => setDepositForm((prev) => ({ ...prev, location: e.target.value }))} />
              <TextField
                select
                label="Controla lote"
                value={depositForm.controls_lot ? "si" : "no"}
                onChange={(e: ChangeEvent<HTMLInputElement>) => setDepositForm((prev) => ({ ...prev, controls_lot: e.target.value === "si" }))}
              >
                <MenuItem value="si">Sí</MenuItem>
                <MenuItem value="no">No</MenuItem>
              </TextField>
              <FormControlLabel
                control={<Switch checked={depositForm.is_store} onChange={(e) => setDepositForm((prev) => ({ ...prev, is_store: e.target.checked }))} />}
                label="Es local (destino de pedidos)"
              />
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {depositForm.id ? "Actualizar" : "Crear"}
                </Button>
                {depositForm.id && (
                  <Button onClick={() => setDepositForm({ name: "", location: "", controls_lot: true, is_store: false })}>Cancelar</Button>
                )}
              </Stack>
            </Stack>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={8}>
        <Card>
          <CardHeader
            title="Depósitos"
            subheader="Listado y edición"
            action={<Chip label={`${filteredDeposits.length} de ${deposits.length}`} />}
          />
          <Divider />
          <CardContent>
            <Box sx={{ mb: 2 }}>
              <TextField
                label="Buscar por nombre o ubicación"
                value={depositSearch}
                onChange={(e) => setDepositSearch(e.target.value)}
                size="small"
                sx={{ maxWidth: 320 }}
              />
            </Box>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Ubicación</TableCell>
                  <TableCell>Controla lote</TableCell>
                  <TableCell>Es local</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {filteredDeposits.map((deposit) => (
                  <TableRow key={deposit.id} hover>
                    <TableCell>{deposit.name}</TableCell>
                    <TableCell>{deposit.location || "—"}</TableCell>
                    <TableCell>{deposit.controls_lot ? "Sí" : "No"}</TableCell>
                    <TableCell>{deposit.is_store ? "Sí" : "No"}</TableCell>
                    <TableCell align="right">
                      <Tooltip title="Editar">
                        <IconButton size="small" onClick={() => startEditDeposit(deposit)}>
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Eliminar">
                        <IconButton size="small" color="error" onClick={() => handleDelete("deposit", deposit.id)}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  const renderRecetas = () => (
    <Grid container spacing={2} alignItems="stretch">
      <Grid item xs={12} md={5}>
        <Card>
          <CardHeader title="Receta" subheader={recipeForm.id ? "Editar" : "Nueva"} avatar={<RestaurantMenuIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleRecipeSubmit}>
              <TextField
                select
                required
                label="Producto (solo PT/SEMI)"
                value={recipeForm.product_id}
                onChange={(e) => setRecipeForm((prev) => ({ ...prev, product_id: e.target.value }))}
              >
                {filteredProducts.map((sku) => (
                  <MenuItem key={sku.id} value={sku.id}>
                    {skuLabel(sku)}
                  </MenuItem>
                ))}
              </TextField>
              <TextField
                label="Nombre de receta"
                value={recipeForm.name}
                placeholder="Si no lo completas usamos el nombre del producto"
                onChange={(e) => setRecipeForm((prev) => ({ ...prev, name: e.target.value }))}
              />
              <Typography variant="subtitle2">Componentes</Typography>
              <Stack spacing={1}>
                {recipeForm.items.map((item, index) => (
                  <Stack key={index} direction="row" spacing={1} alignItems="center">
                    <TextField
                      select
                      required
                      label="Componente"
                      sx={{ flex: 1 }}
                      value={item.component_id}
                      onChange={(e) => handleRecipeItemChange(index, "component_id", e.target.value)}
                    >
                      {recipeComponents.map((sku) => (
                        <MenuItem key={sku.id} value={sku.id}>
                          {skuLabel(sku)}
                        </MenuItem>
                      ))}
                    </TextField>
                    <TextField label="Unidad" value={recipeItemUnit(item.component_id)} sx={{ width: 140 }} InputProps={{ readOnly: true }} />
                    <TextField
                      required
                      label="Cantidad"
                      type="number"
                      inputProps={{ step: "0.01" }}
                      sx={{ width: 140 }}
                      value={item.quantity}
                      onChange={(e) => handleRecipeItemChange(index, "quantity", e.target.value)}
                    />
                    <Tooltip title="Eliminar">
                      <span>
                        <IconButton color="error" disabled={recipeForm.items.length <= 1} onClick={() => removeRecipeItem(index)}>
                          <DeleteIcon />
                        </IconButton>
                      </span>
                    </Tooltip>
                  </Stack>
                ))}
                <Button startIcon={<LibraryAddIcon />} onClick={addRecipeItem} variant="outlined">
                  Agregar componente
                </Button>
              </Stack>
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {recipeForm.id ? "Actualizar" : "Guardar"}
                </Button>
                {recipeForm.id && (
                  <Button onClick={() => setRecipeForm({ id: undefined, product_id: "", name: "", items: [{ component_id: "", quantity: "" }] })}>
                    Cancelar
                  </Button>
                )}
              </Stack>
            </Stack>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={7}>
        <Card>
          <CardHeader
            title="Recetas registradas"
            subheader="Listado compacto (sin previsualizar ingredientes)"
            action={<Chip label={`${filteredRecipes.length} de ${recipes.length}`} />}
          />
          <Divider />
          <CardContent>
            <Box sx={{ mb: 2 }}>
              <TextField
                label="Buscar por nombre o producto"
                value={recipeSearch}
                onChange={(e) => setRecipeSearch(e.target.value)}
                size="small"
                sx={{ maxWidth: 320 }}
              />
            </Box>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Receta</TableCell>
                  <TableCell>Producto</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {filteredRecipes.map((recipe) => (
                  <TableRow key={recipe.id} hover>
                    <TableCell>{recipe.name || "Receta"}</TableCell>
                    <TableCell>{skuMap.get(recipe.product_id) ? skuLabel(skuMap.get(recipe.product_id) as SKU) : `SKU ${recipe.product_id}`}</TableCell>
                    <TableCell align="right">
                      <Tooltip title="Editar">
                        <IconButton size="small" onClick={() => startEditRecipe(recipe)}>
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Eliminar">
                        <IconButton size="small" color="error" onClick={() => handleDelete("recipe", recipe.id)}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  const renderUsuarios = () => (
    <Grid container spacing={2} alignItems="stretch">
      <Grid item xs={12} md={5}>
        <Card>
          <CardHeader title="Usuario" subheader={userForm.id ? "Editar" : "Nuevo"} avatar={<AdminPanelSettingsIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleUserSubmit}>
              <TextField label="Email" required value={userForm.email} onChange={(e) => setUserForm((prev) => ({ ...prev, email: e.target.value }))} />
              <TextField label="Nombre" required value={userForm.full_name} onChange={(e) => setUserForm((prev) => ({ ...prev, full_name: e.target.value }))} />
              <TextField
                label={userForm.id ? "Nueva contraseña (opcional)" : "Contraseña"}
                type="password"
                required={!userForm.id}
                value={userForm.password}
                onChange={(e) => setUserForm((prev) => ({ ...prev, password: e.target.value }))}
              />
              <TextField
                select
                label="Rol"
                value={userForm.role_id}
                onChange={(e) => setUserForm((prev) => ({ ...prev, role_id: e.target.value }))}
                helperText="Opcional"
              >
                <MenuItem value="">Sin rol</MenuItem>
                {roles.map((role) => (
                  <MenuItem key={role.id} value={role.id}>
                    {role.name}
                  </MenuItem>
                ))}
              </TextField>
              <TextField
                select
                label="Estado"
                value={userForm.is_active ? "activo" : "inactivo"}
                onChange={(e) => setUserForm((prev) => ({ ...prev, is_active: e.target.value === "activo" }))}
              >
                <MenuItem value="activo">Activo</MenuItem>
                <MenuItem value="inactivo">Inactivo</MenuItem>
              </TextField>
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {userForm.id ? "Actualizar" : "Crear"}
                </Button>
                {userForm.id && (
                  <Button onClick={() => setUserForm({ id: undefined, email: "", full_name: "", password: "", role_id: "", is_active: true })}>
                    Cancelar
                  </Button>
                )}
              </Stack>
            </Stack>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={7}>
        <Card>
          <CardHeader
            title="Usuarios"
            subheader="Alta, baja y modificación"
            action={<Chip label={`${filteredUsers.length} de ${users.length}`} />}
          />
          <Divider />
          <CardContent>
            <Box sx={{ mb: 2 }}>
              <TextField
                label="Buscar por nombre, email o rol"
                value={userSearch}
                onChange={(e) => setUserSearch(e.target.value)}
                size="small"
                sx={{ maxWidth: 320 }}
              />
            </Box>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Email</TableCell>
                  <TableCell>Rol</TableCell>
                  <TableCell>Estado</TableCell>
                  <TableCell align="right">Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {filteredUsers.map((user) => (
                  <TableRow key={user.id} hover>
                    <TableCell>{user.full_name}</TableCell>
                    <TableCell>{user.email}</TableCell>
                    <TableCell>{user.role_name || "—"}</TableCell>
                    <TableCell>{user.is_active ? "Activo" : "Inactivo"}</TableCell>
                    <TableCell align="right">
                      <Tooltip title="Editar">
                        <IconButton size="small" onClick={() => startEditUser(user)}>
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Eliminar">
                        <IconButton size="small" color="error" onClick={() => handleDelete("user", user.id)}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  const renderClientes = () => (
    <Grid container spacing={3}>
      <Grid item xs={12} md={5}>
        <Card>
          <CardHeader title={clientForm.id ? "Editar cliente" : "Nuevo cliente"} avatar={<PeopleIcon color="primary" />} />
          <Divider />
          <CardContent>
            <Stack component="form" spacing={2} onSubmit={handleClientSubmit}>
              <TextField
                label="Nombre"
                value={clientForm.name}
                onChange={(event) => setClientForm((prev) => ({ ...prev, name: event.target.value }))}
                required
              />
              <TextField
                select
                label="Tipo de cliente"
                value={clientForm.client_type}
                onChange={(event) => setClientForm((prev) => ({ ...prev, client_type: event.target.value }))}
                required
              >
                {CLIENT_TYPE_OPTIONS.map((option) => (
                  <MenuItem key={option.value} value={option.value}>
                    {option.label}
                  </MenuItem>
                ))}
              </TextField>
              <FormControlLabel
                control={
                  <Switch
                    checked={clientForm.is_active}
                    onChange={(event) => setClientForm((prev) => ({ ...prev, is_active: event.target.checked }))}
                  />
                }
                label="Cliente activo"
              />
              <Stack direction="row" spacing={1}>
                <Button type="submit" variant="contained">
                  {clientForm.id ? "Guardar cambios" : "Crear cliente"}
                </Button>
                {clientForm.id && (
                  <Button onClick={() => setClientForm({ id: undefined, name: "", client_type: "empresa", is_active: true })}>
                    Cancelar
                  </Button>
                )}
              </Stack>
            </Stack>
          </CardContent>
        </Card>
        <Card sx={{ mt: 3 }}>
          <CardHeader title="Clientes" action={<Chip label={`${filteredClients.length} de ${clients.length}`} />} />
          <Divider />
          <CardContent>
            <Stack spacing={2}>
              <TextField
                label="Buscar"
                value={clientSearch}
                onChange={(event) => setClientSearch(event.target.value)}
                size="small"
                placeholder="Nombre o tipo"
                sx={{ maxWidth: 320 }}
              />
              <FormControlLabel
                control={
                  <Switch checked={showInactiveClients} onChange={(event) => setShowInactiveClients(event.target.checked)} />
                }
                label="Mostrar inactivos"
              />
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Cliente</TableCell>
                    <TableCell>Tipo</TableCell>
                    <TableCell>Estado</TableCell>
                    <TableCell align="right">Acciones</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredClients.map((client) => (
                    <TableRow
                      key={client.id}
                      hover
                      selected={selectedClientId === client.id}
                      onClick={() => setSelectedClientId(client.id)}
                      sx={{ cursor: "pointer" }}
                    >
                      <TableCell>{client.name}</TableCell>
                      <TableCell>
                        {CLIENT_TYPE_OPTIONS.find((option) => option.value === client.client_type)?.label ?? client.client_type}
                      </TableCell>
                      <TableCell>{client.is_active ? "Activo" : "Inactivo"}</TableCell>
                      <TableCell align="right">
                        <Tooltip title="Editar">
                          <IconButton size="small" onClick={() => startEditClient(client)}>
                            <EditIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Eliminar">
                          <IconButton size="small" color="error" onClick={() => handleDelete("client", client.id)}>
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </Stack>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={7}>
        <Card>
          <CardHeader title="Apoderados" subheader={selectedClient ? `Cliente: ${selectedClient.name}` : "Selecciona un cliente"} />
          <Divider />
          <CardContent>
            <Stack spacing={2}>
              <TextField
                select
                label="Cliente"
                value={selectedClientId}
                onChange={(event) => {
                  setSelectedClientId(event.target.value ? Number(event.target.value) : "");
                  setRepresentativeForm({
                    id: undefined,
                    full_name: "",
                    person_type: "fisica",
                    document_type: "DNI",
                    document_number: "",
                    email: "",
                    phone: "",
                    address: "",
                    notes: "",
                    is_active: true,
                  });
                }}
              >
                {clients.map((client) => (
                  <MenuItem key={client.id} value={client.id}>
                    {client.name}
                  </MenuItem>
                ))}
              </TextField>
              <Stack component="form" spacing={2} onSubmit={handleRepresentativeSubmit}>
                <TextField
                  label="Nombre completo"
                  value={representativeForm.full_name}
                  onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, full_name: event.target.value }))}
                  required
                />
                <Grid container spacing={2}>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      select
                      label="Tipo de persona"
                      value={representativeForm.person_type}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, person_type: event.target.value }))}
                      required
                      fullWidth
                    >
                      {PERSON_TYPE_OPTIONS.map((option) => (
                        <MenuItem key={option.value} value={option.value}>
                          {option.label}
                        </MenuItem>
                      ))}
                    </TextField>
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      select
                      label="Documento"
                      value={representativeForm.document_type}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, document_type: event.target.value }))}
                      required
                      fullWidth
                    >
                      {DOCUMENT_TYPE_OPTIONS.map((option) => (
                        <MenuItem key={option.value} value={option.value}>
                          {option.label}
                        </MenuItem>
                      ))}
                    </TextField>
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      label="Número"
                      value={representativeForm.document_number}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, document_number: event.target.value }))}
                      required
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      label="Email"
                      value={representativeForm.email}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, email: event.target.value }))}
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      label="Teléfono"
                      value={representativeForm.phone}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, phone: event.target.value }))}
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      label="Dirección"
                      value={representativeForm.address}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, address: event.target.value }))}
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12}>
                    <TextField
                      label="Notas"
                      value={representativeForm.notes}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, notes: event.target.value }))}
                      fullWidth
                    />
                  </Grid>
                </Grid>
                <FormControlLabel
                  control={
                    <Switch
                      checked={representativeForm.is_active}
                      onChange={(event) => setRepresentativeForm((prev) => ({ ...prev, is_active: event.target.checked }))}
                    />
                  }
                  label="Apoderado activo"
                />
                <Stack direction="row" spacing={1}>
                  <Button type="submit" variant="contained" disabled={!selectedClientId}>
                    {representativeForm.id ? "Guardar cambios" : "Agregar apoderado"}
                  </Button>
                  {representativeForm.id && (
                    <Button
                      onClick={() =>
                        setRepresentativeForm({
                          id: undefined,
                          full_name: "",
                          person_type: "fisica",
                          document_type: "DNI",
                          document_number: "",
                          email: "",
                          phone: "",
                          address: "",
                          notes: "",
                          is_active: true,
                        })
                      }
                    >
                      Cancelar
                    </Button>
                  )}
                </Stack>
              </Stack>
              <Divider />
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Apoderado</TableCell>
                    <TableCell>Tipo</TableCell>
                    <TableCell>Documento</TableCell>
                    <TableCell>Estado</TableCell>
                    <TableCell align="right">Acciones</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {clientRepresentatives.map((representative) => (
                    <TableRow key={representative.id} hover>
                      <TableCell>{representative.full_name}</TableCell>
                      <TableCell>
                        {PERSON_TYPE_OPTIONS.find((option) => option.value === representative.person_type)?.label ??
                          representative.person_type}
                      </TableCell>
                      <TableCell>
                        {representative.document_type} {representative.document_number}
                      </TableCell>
                      <TableCell>{representative.is_active ? "Activo" : "Inactivo"}</TableCell>
                      <TableCell align="right">
                        <Tooltip title="Editar">
                          <IconButton size="small" onClick={() => startEditRepresentative(representative)}>
                            <EditIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Eliminar">
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleDelete("representative", representative.id, representative.client_id)}
                          >
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </Stack>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  return (
    <Stack spacing={2}>
      <Typography variant="h5" sx={{ display: "flex", alignItems: "center", gap: 1 }}>
        <AdminPanelSettingsIcon color="primary" /> Administración de maestros
      </Typography>
      {error && <Alert severity="warning">{error}</Alert>}
      {success && (
        <Alert severity="success" onClose={() => resetMessages()}>
          {success}
        </Alert>
      )}
      <Card>
        <Tabs
          value={tab}
          onChange={(_, value) => {
            resetMessages();
            setTab(value);
          }}
          variant="scrollable"
          scrollButtons
          allowScrollButtonsMobile
        >
          <Tab label="Productos" value="productos" icon={<InventoryIcon />} iconPosition="start" />
          <Tab label="Recetas" value="recetas" icon={<RestaurantMenuIcon />} iconPosition="start" />
          <Tab label="Depósitos" value="depositos" icon={<StoreIcon />} iconPosition="start" />
          <Tab label="Usuarios" value="usuarios" icon={<AdminPanelSettingsIcon />} iconPosition="start" />
          <Tab label="Clientes" value="clientes" icon={<PeopleIcon />} iconPosition="start" />
          <Tab label="Catálogos" value="catalogos" icon={<LibraryAddIcon />} iconPosition="start" />
        </Tabs>
        <Divider />
        <CardContent>
          {tab === "productos" && renderProductos()}
          {tab === "recetas" && renderRecetas()}
          {tab === "depositos" && renderDepositos()}
          {tab === "usuarios" && renderUsuarios()}
          {tab === "clientes" && renderClientes()}
          {tab === "catalogos" && renderCatalogos()}
        </CardContent>
      </Card>
      <Box sx={{ color: "text.secondary", fontSize: 12 }}>
        Pantalla única para altas, bajas y modificaciones de productos, recetas, depósitos, usuarios, clientes y catálogos base.
      </Box>
    </Stack>
  );
}

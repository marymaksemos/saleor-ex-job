import * as ToggleGroup from "@radix-ui/react-toggle-group";
import { buttonVariants } from "@/components/ui/button";
import { type ProductListItemFragment } from "@/gql/graphql";
import { cn } from "@/lib/utils";

interface ProductVariantsProps {
	product: ProductListItemFragment;
	defaultValue?: string;
	onValueChange: (value: string) => void;
}

export const ProductVariants = ({ product, defaultValue, onValueChange }: ProductVariantsProps) => {
	return (
		<ToggleGroup.Root
			type="single"
			defaultValue={defaultValue}
			onValueChange={onValueChange}
			className="flex flex-wrap justify-center gap-2"
			aria-label="Product Variants"
		>
			{product.variants &&
				product.variants.map((variant) => (
					<ToggleGroup.Item
						key={variant.id}
						disabled={!variant.quantityAvailable}
						className={cn(
							buttonVariants({ variant: "outline", size: "xs" }),
							"min-w-8 data-[state=on]:bg-black data-[state=on]:text-white",
						)}
						value={variant.id}
						aria-label={variant.name}
					>
						{variant.name}
					</ToggleGroup.Item>
				))}
		</ToggleGroup.Root>
	);
};

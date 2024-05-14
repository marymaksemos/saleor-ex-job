"use client";
import { useState } from "react";
import { XIcon } from "lucide-react";
import { useParams } from "next/navigation";
import { Button } from "@/components/ui/button";
import { ProductVariants } from "@/ui/components/ProductVariants";
import { type ProductListItemFragment } from "@/gql/graphql";
import { addItem } from "@/actions/addItem";
import { CartButton } from "@/components/ui/cart-button";

interface ProductQuickAddProps {
	product: ProductListItemFragment;
	hasQuickAdd: boolean;
}

export const ProductQuickAdd = ({ product, hasQuickAdd = false }: ProductQuickAddProps) => {
	const { channel } = useParams<{ channel: string }>();
	const [isQuick, setIsQuick] = useState(false);
	const [loading, setLoading] = useState(false);
	const [variant, setVariant] = useState(product.variants?.at(0)?.id);

	const toggleQuickView = () => {
		setIsQuick((prev) => !prev);
	};

	const handleAddItem = async () => {
		setLoading(true);
		await addItem({ channel, variant });
		setLoading(false);
		setIsQuick(false);
	};

	const cartButton = (
		<CartButton onClick={handleAddItem} disabled={loading || !variant} className="w-full">
			{loading ? "Proccessing..." : "Add To Cart"}
		</CartButton>
	);

	return (
		<>
			{isQuick && (
				<div className="absolute inset-0 flex flex-col justify-end bg-gray-700/60 backdrop-blur-sm">
					<div className=" bottom-0 flex w-full flex-col justify-between gap-4 bg-white">
						<Button onClick={toggleQuickView} variant="link" size="xs" className="self-end">
							<XIcon className="h-4 w-4" />
						</Button>
						<ProductVariants
							product={product}
							defaultValue={variant}
							onValueChange={(value) => setVariant(value)}
						/>
						{cartButton}
					</div>
				</div>
			)}
			{hasQuickAdd ? (
				<CartButton onClick={toggleQuickView} className="w-full">
					Quick Add
				</CartButton>
			) : (
				cartButton
			)}
		</>
	);
};
